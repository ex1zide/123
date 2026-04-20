import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { GoogleGenerativeAI } from "@google/generative-ai";

admin.initializeApp();
const db = admin.firestore();

// ════════════════════════════════════════════════════════════
// CONFIGURATION
// ════════════════════════════════════════════════════════════

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || "";
const KNOWLEDGE_COLLECTION = "knowledge_base";
const MAX_RAG_RESULTS = 5;

const PLAN_LIMITS: Record<string, number> = {
    free: 10,
    pro: 999999,
    business: 999999,
};

const SYSTEM_PROMPT =
    "Ты — корпоративный ИИ-юрист Республики Казахстан. " +
    "Твоя задача — давать точные юридические консультации, " +
    "строго основываясь на переданном контексте (законодательстве РК). " +
    "КАТЕГОРИЧЕСКИ ЗАПРЕЩЕНО выдумывать статьи, нормы или факты. " +
    "Если в переданном контексте нет ответа на вопрос пользователя, " +
    "честно сообщи об этом и предложи обратиться к живому юристу " +
    "через маркетплейс LegalHelp KZ. " +
    "Формат ответа: структурированный, с нумерацией пунктов, " +
    "ссылками на конкретные статьи и кодексы. " +
    "Язык: отвечай на том языке, на котором задан вопрос.";

// ════════════════════════════════════════════════════════════
// HELPERS
// ════════════════════════════════════════════════════════════

/**
 * Extracts keywords from a user query (mirrors client-side logic).
 * In production, replace with a proper NLP tokenizer.
 */
function extractKeywords(query: string): string[] {
    const stopWords = new Set([
        "и", "в", "на", "за", "к", "по", "из", "о", "у", "с",
        "что", "как", "это", "мне", "мой", "для", "не", "да",
        "ли", "но", "а", "же", "бы", "от", "до", "при",
    ]);

    return query
        .toLowerCase()
        .replace(/[^\wа-яёәіңғүұқөһ\s]/g, "")
        .split(/\s+/)
        .filter((w) => w.length > 2 && !stopWords.has(w))
        .slice(0, 10);
}

/**
 * RAG: searches knowledge_base for relevant legal articles.
 */
async function searchKnowledgeBase(query: string): Promise<string> {
    const keywords = extractKeywords(query);
    if (keywords.length === 0) {
        return "КОНТЕКСТ: Релевантные статьи законодательства РК не найдены. " +
            "Предложи пользователю обратиться к живому юристу через маркетплейс.";
    }

    const snapshot = await db
        .collection(KNOWLEDGE_COLLECTION)
        .where("keywords", "array-contains-any", keywords)
        .limit(MAX_RAG_RESULTS)
        .get();

    if (snapshot.empty) {
        return "КОНТЕКСТ: Релевантные статьи законодательства РК не найдены. " +
            "Предложи пользователю обратиться к живому юристу через маркетплейс.";
    }

    let context = "КОНТЕКСТ ЗАКОНОДАТЕЛЬСТВА РК:\n\n";
    for (const doc of snapshot.docs) {
        const d = doc.data();
        context += `━━━ ${d.codeName || ""}, ${d.articleNumber || ""} ━━━\n`;
        context += `Заголовок: ${d.title || ""}\n`;
        context += `Текст: ${d.content || ""}\n\n`;
    }
    context += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    context += "СТРОГО отвечай на основе приведенного контекста.\n";

    return context;
}

/**
 * Input sanitization — strips common prompt injection patterns.
 */
function sanitizeInput(input: string): string {
    const dangerousPatterns = [
        /игнорируй\s+(все\s+)?предыдущие\s+инструкции/gi,
        /ignore\s+(all\s+)?previous\s+instructions/gi,
        /system\s*prompt/gi,
        /выведи\s+свой\s+(системный\s+)?промпт/gi,
        /ты\s+теперь\s+/gi,
        /you\s+are\s+now\s+/gi,
    ];

    let sanitized = input;
    for (const pattern of dangerousPatterns) {
        sanitized = sanitized.replace(pattern, "[FILTERED]");
    }
    return sanitized.trim();
}

// ════════════════════════════════════════════════════════════
// MAIN CALLABLE: askAI
// ════════════════════════════════════════════════════════════

export const askAI = functions.https.onCall(async (data, context) => {
    // ── 1. Auth Check ──
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "Авторизация обязательна для использования ИИ-юриста."
        );
    }

    const uid = context.auth.uid;
    const question = data?.question;

    if (!question || typeof question !== "string" || question.trim().length === 0) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Вопрос не может быть пустым."
        );
    }

    // ── 2. Subscription Check ──
    const subRef = db.doc(`users/${uid}/subscription/status`);
    const subSnap = await subRef.get();

    let plan = "free";
    let usedQueries = 0;
    let maxQueries = PLAN_LIMITS["free"];

    if (subSnap.exists) {
        const subData = subSnap.data()!;
        plan = subData.plan || "free";
        usedQueries = subData.usedQueries || 0;
        maxQueries = PLAN_LIMITS[plan] || PLAN_LIMITS["free"];
    } else {
        // First time user — create subscription doc
        await subRef.set({
            plan: "free",
            usedQueries: 0,
            maxQueries: PLAN_LIMITS["free"],
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }

    if (plan === "free" && usedQueries >= maxQueries) {
        throw new functions.https.HttpsError(
            "resource-exhausted",
            "Лимит бесплатных запросов исчерпан. Перейдите на PRO."
        );
    }

    // ── 3. Sanitize input ──
    const sanitizedQuestion = sanitizeInput(question);

    // ── 4. RAG Retrieval ──
    const ragContext = await searchKnowledgeBase(sanitizedQuestion);

    // ── 5. Gemini Call ──
    if (!GEMINI_API_KEY) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "Gemini API key not configured on server."
        );
    }

    const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
    const model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
        systemInstruction: SYSTEM_PROMPT,
    });

    const fullPrompt = `${ragContext}\n\nВОПРОС ПОЛЬЗОВАТЕЛЯ:\n${sanitizedQuestion}`;

    const result = await model.generateContent(fullPrompt);
    const response = result.response;
    const aiText = response.text() ||
        "Извините, я не смог сформулировать ответ.";

    // ── 6. Increment query counter (Free users only) ──
    if (plan === "free") {
        await subRef.update({
            usedQueries: admin.firestore.FieldValue.increment(1),
        });
    }

    // ── 7. Return response ──
    return {
        answer: aiText,
        plan: plan,
        usedQueries: usedQueries + (plan === "free" ? 1 : 0),
        maxQueries: maxQueries,
    };
});

// ════════════════════════════════════════════════════════════
// ADMIN: upgradePlan (callable by payment webhook or admin)
// ════════════════════════════════════════════════════════════

export const upgradePlan = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "Auth required.");
    }

    const uid = context.auth.uid;
    const newPlan = data?.plan;

    if (!newPlan || !["pro", "business"].includes(newPlan)) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Plan must be 'pro' or 'business'."
        );
    }

    const subRef = db.doc(`users/${uid}/subscription/status`);
    await subRef.set({
        plan: newPlan,
        usedQueries: 0,
        maxQueries: PLAN_LIMITS[newPlan],
        upgradedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    return { success: true, plan: newPlan };
});

// ════════════════════════════════════════════════════════════
// CONTRACT ANALYZER: analyzeContract
// ════════════════════════════════════════════════════════════

const CONTRACT_SYSTEM_PROMPT =
    "Ты — корпоративный юрист Республики Казахстан, специализирующийся на анализе договоров. " +
    "Проанализируй переданный текст договора. " +
    "Если есть скрытые риски, штрафы, невыгодные условия или потенциально опасные пункты — " +
    "выведи их пронумерованным списком, каждый риск на отдельной строке. " +
    "Начни каждый риск со слова 'РИСК:'. " +
    "Если договор составлен идеально и безопасно — ответь РОВНО одной строкой: " +
    "'CLEAN: Отличный договор, юридических рисков не обнаружено.' " +
    "Язык ответа: русский.";

export const analyzeContract = functions.https.onCall(async (data, context) => {
    // ── 1. Auth Check ──
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "Авторизация обязательна."
        );
    }

    const contractText = data?.contractText;

    if (!contractText || typeof contractText !== "string" || contractText.trim().length < 10) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Текст договора слишком короткий или отсутствует."
        );
    }

    // ── 2. Subscription Check (contract analysis counts as a query) ──
    const uid = context.auth.uid;
    const subRef = db.doc(`users/${uid}/subscription/status`);
    const subSnap = await subRef.get();

    let plan = "free";
    let usedQueries = 0;
    let maxQueries = PLAN_LIMITS["free"];

    if (subSnap.exists) {
        const subData = subSnap.data()!;
        plan = subData.plan || "free";
        usedQueries = subData.usedQueries || 0;
        maxQueries = PLAN_LIMITS[plan] || PLAN_LIMITS["free"];
    }

    if (plan === "free" && usedQueries >= maxQueries) {
        throw new functions.https.HttpsError(
            "resource-exhausted",
            "Лимит бесплатных запросов исчерпан. Перейдите на PRO."
        );
    }

    // ── 3. Sanitize ──
    const sanitizedText = sanitizeInput(contractText);

    // ── 4. Gemini Call ──
    if (!GEMINI_API_KEY) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "Gemini API key not configured on server."
        );
    }

    const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
    const model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
        systemInstruction: CONTRACT_SYSTEM_PROMPT,
    });

    const result = await model.generateContent(
        `ТЕКСТ ДОГОВОРА:\n\n${sanitizedText}`
    );
    const response = result.response;
    const aiText = response.text() || "";

    // ── 5. Increment query counter ──
    if (plan === "free") {
        await subRef.update({
            usedQueries: admin.firestore.FieldValue.increment(1),
        });
    }

    // ── 6. Parse risks ──
    const isClean = aiText.trim().startsWith("CLEAN:");
    const risks: string[] = [];

    if (!isClean) {
        const lines = aiText.split("\n");
        for (const line of lines) {
            const trimmed = line.trim();
            if (trimmed.startsWith("РИСК:")) {
                risks.push(trimmed.replace("РИСК:", "").trim());
            } else if (/^\d+[\.\)]/.test(trimmed) && trimmed.length > 5) {
                risks.push(trimmed.replace(/^\d+[\.\)]\s*/, ""));
            }
        }
    }

    return {
        analysis: aiText,
        risksFound: !isClean && risks.length > 0,
        risks: risks,
    };
});
