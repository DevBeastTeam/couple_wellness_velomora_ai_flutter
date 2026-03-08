import {
    collection,
    doc,
    getDocs,
    setDoc,
    updateDoc,
    deleteDoc,
    serverTimestamp,
    query,
    orderBy
} from 'firebase/firestore';
import { db } from './firebase';

export interface SubscriptionPlan {
    id: string;
    name: string;
    productId: string;
    durationMonths: number;
    pricePerMonth: number;
    totalPrice: number;
    currency: string;
    badge?: string;
    badgeColor?: string;
    savingsText?: string;
    bottomNote?: string;
    features: string[];
    isActive: boolean;
    isPopular: boolean;
    sortOrder: number;
    createdAt?: any;
    updatedAt?: any;
}

const COLLECTION = 'subscription_plans';

export const subscriptionPlanService = {
    getPlans: async (): Promise<SubscriptionPlan[]> => {
        const q = query(collection(db, COLLECTION), orderBy('sortOrder', 'asc'));
        const snapshot = await getDocs(q);
        return snapshot.docs.map(d => ({ id: d.id, ...d.data() } as SubscriptionPlan));
    },

    createPlan: async (plan: Omit<SubscriptionPlan, 'id' | 'createdAt' | 'updatedAt'>): Promise<string> => {
        const ref = doc(collection(db, COLLECTION));
        await setDoc(ref, {
            ...plan,
            createdAt: serverTimestamp(),
            updatedAt: serverTimestamp()
        });
        return ref.id;
    },

    updatePlan: async (id: string, plan: Partial<SubscriptionPlan>): Promise<void> => {
        await updateDoc(doc(db, COLLECTION, id), {
            ...plan,
            updatedAt: serverTimestamp()
        });
    },

    deletePlan: async (id: string): Promise<void> => {
        await deleteDoc(doc(db, COLLECTION, id));
    },

    seedDefaultPlans: async (): Promise<void> => {
        const defaults: Omit<SubscriptionPlan, 'id'>[] = [
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
                features: [],
                isActive: true,
                isPopular: false,
                sortOrder: 1,
                createdAt: serverTimestamp(),
                updatedAt: serverTimestamp()
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
                features: [],
                isActive: true,
                isPopular: false,
                sortOrder: 2,
                createdAt: serverTimestamp(),
                updatedAt: serverTimestamp()
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
                features: [],
                isActive: true,
                isPopular: true,
                sortOrder: 3,
                createdAt: serverTimestamp(),
                updatedAt: serverTimestamp()
            }
        ];

        for (const plan of defaults) {
            const ref = doc(collection(db, COLLECTION));
            await setDoc(ref, plan);
        }
    }
};
