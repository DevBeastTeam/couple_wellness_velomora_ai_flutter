import {
    collection,
    doc,
    setDoc,
    addDoc,
    getDocs,
    deleteDoc,
    serverTimestamp,
    query
} from 'firebase/firestore';
import {
    createUserWithEmailAndPassword
} from 'firebase/auth';
import { db, auth } from './firebase';

// Helper to clear all documents in a collection
const clearCollection = async (collectionName: string) => {
    const snap = await getDocs(query(collection(db, collectionName)));
    const deletes = snap.docs.map(d => deleteDoc(doc(db, collectionName, d.id)));
    await Promise.all(deletes);
};

export const seedService = {
    seedAdmin: async () => {
        const email = 'admin@gmail.com';
        const password = '12345678';

        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password);
            const uid = userCredential.user.uid;
            await setDoc(doc(db, 'admins', uid), {
                uid, email, role: 'Super Admin', createdAt: serverTimestamp()
            });
            return { success: true, message: 'Admin user created successfully.' };
        } catch (error: any) {
            if (error.code === 'auth/email-already-in-use') {
                const currentUser = auth.currentUser;
                if (currentUser) {
                    await setDoc(doc(db, 'admins', currentUser.uid), {
                        uid: currentUser.uid, email: currentUser.email,
                        role: 'Super Admin', createdAt: serverTimestamp()
                    }, { merge: true });
                }
                return { success: true, message: 'Admin already existed, roles ensured.' };
            }
            throw error;
        }
    },

    seedDummyData: async (progressCallback: (msg: string) => void) => {
        // ── AI Config ──────────────────────────────────────────────────────────
        progressCallback('Seeding AI Configuration...');
        await setDoc(doc(db, 'ai_config', 'settings'), {
            apiKey: 'PLACEHOLDER_KEY',
            model: 'gemini-2.0-flash',
            temperature: 0.7,
            maxTokens: 500,
            topK: 40,
            topP: 0.95,
            systemInstruction: 'You are Velmora AI, a helpful relationship coach.',
            safetySettings: {
                harassment: 'BLOCK_MEDIUM_AND_ABOVE',
                hateSpeech: 'BLOCK_MEDIUM_AND_ABOVE',
                sexuallyExplicit: 'BLOCK_MEDIUM_AND_ABOVE',
                dangerousContent: 'BLOCK_MEDIUM_AND_ABOVE'
            },
            updatedAt: serverTimestamp()
        });

        // ── Dummy Users ────────────────────────────────────────────────────────
        progressCallback('Seeding Dummy Users...');
        const dummyUsers = [
            { displayName: 'John Doe', email: 'john@example.com', subscriptionStatus: 'premium', preferredLanguage: 'en' },
            { displayName: 'Jane Smith', email: 'jane@example.com', subscriptionStatus: 'trial', preferredLanguage: 'fr' },
            { displayName: 'Ahmed Ali', email: 'ahmed@example.com', subscriptionStatus: 'free', preferredLanguage: 'ar' },
        ];
        for (const user of dummyUsers) {
            await addDoc(collection(db, 'users'), {
                ...user,
                createdAt: serverTimestamp(),
                lastLoginAt: serverTimestamp(),
                featuresAccess: { games: true, kegel: true, chat: true }
            });
        }

        // ── Games ──────────────────────────────────────────────────────────────
        progressCallback('Seeding Game Definitions...');
        const games = [
            { id: 'truth_or_truth', name: 'Truth or Truth', description: 'Deep questions for couples', premium: false },
            { id: 'love_language', name: 'Love Language Quiz', description: 'Discover your love language', premium: true },
            { id: 'reflection', name: 'Reflection & Discussion', description: 'Monthly relationship check-in', premium: true },
        ];
        for (const game of games) {
            await setDoc(doc(db, 'games', game.id), { ...game, isActive: true, updatedAt: serverTimestamp() });
        }

        // ── Legal ──────────────────────────────────────────────────────────────
        progressCallback('Seeding Legal Documents...');
        await setDoc(doc(db, 'admin', 'legal_docs', 'items', 'privacy_policy'), {
            content: 'Privacy Policy content here...', updatedAt: serverTimestamp()
        });

        // ── Subscription Plans ─────────────────────────────────────────────────
        // Matches EXACTLY what the Flutter app's subscription screen displays.
        progressCallback('Clearing old subscription plans...');
        await clearCollection('subscription_plans');

        progressCallback('Seeding Subscription Plans...');
        const subscriptionPlans = [
            {
                name: 'Monthly Plan',
                productId: 'velmora_premium_monthly',
                durationMonths: 1,
                pricePerMonth: 4.99,
                totalPrice: 4.99,
                currency: 'USD',
                badge: '',
                badgeColor: '',
                savingsText: '',
                bottomNote: 'Free for 48 hours, then $4.99/month. Cancel anytime.',
                features: [
                    'Full AI Chat',
                    'All Games',
                    'Kegel Exercises',
                    'Priority Support'
                ],
                isActive: true,
                isPopular: false,
                sortOrder: 1
            },
            {
                name: '3-Month Plan',
                productId: 'velmora_premium_quarterly',
                durationMonths: 3,
                pricePerMonth: 3.33,
                totalPrice: 9.99,
                currency: 'USD',
                badge: 'SAVE 33%',
                badgeColor: '#FF8A00',
                savingsText: 'Save 33% compared to monthly',
                bottomNote: '',
                features: [
                    'Full AI Chat',
                    'All Games',
                    'Kegel Exercises',
                    'Priority Support',
                    'Exclusive Content'
                ],
                isActive: true,
                isPopular: false,
                sortOrder: 2
            },
            {
                name: 'Yearly Plan',
                productId: 'velmora_premium_yearly',
                durationMonths: 12,
                pricePerMonth: 2.50,
                totalPrice: 29.99,
                currency: 'USD',
                badge: 'BEST VALUE',
                badgeColor: '#FF8A00',
                savingsText: 'Save 50% compared to monthly',
                bottomNote: '',
                features: [
                    'Full AI Chat',
                    'All Games',
                    'Kegel Exercises',
                    'Priority Support',
                    'Exclusive Content',
                    'Early Access'
                ],
                isActive: true,
                isPopular: true,
                sortOrder: 3
            }
        ];

        for (const plan of subscriptionPlans) {
            await addDoc(collection(db, 'subscription_plans'), {
                ...plan,
                createdAt: serverTimestamp(),
                updatedAt: serverTimestamp()
            });
        }

        progressCallback('Migration Complete! ✅');
    }
};
