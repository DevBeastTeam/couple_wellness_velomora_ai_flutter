import {
    collection,
    query,
    limit,
    getDocs,
    doc,
    getDoc,
    updateDoc
} from 'firebase/firestore';
import { db } from './firebase';

export interface UserProfile {
    uid: string;
    displayName: string;
    email: string;
    photoURL?: string;
    subscriptionStatus: 'free' | 'trial' | 'premium';
    preferredLanguage: string;
    lastLoginAt: any;
    createdAt: any;
    featuresAccess?: Record<string, boolean>;
}

export const userService = {
    getUsers: async (pageSize = 10) => {
        const q = query(collection(db, 'users'), limit(pageSize));
        const querySnapshot = await getDocs(q);
        return querySnapshot.docs.map(doc => ({ uid: doc.id, ...doc.data() } as UserProfile));
    },

    getUserById: async (uid: string) => {
        const userDoc = await getDoc(doc(db, 'users', uid));
        if (userDoc.exists()) {
            return { uid: userDoc.id, ...userDoc.data() } as UserProfile;
        }
        return null;
    },

    updateUserSubscription: async (uid: string, status: 'free' | 'trial' | 'premium') => {
        await updateDoc(doc(db, 'users', uid), { subscriptionStatus: status });
    }
};
