import {
    signInWithEmailAndPassword,
    signOut,
    User
} from 'firebase/auth';
import { auth, db } from './firebase';
import { doc, getDoc } from 'firebase/firestore';

export interface AdminUser extends User {
    role?: 'Super Admin' | 'Moderator';
}

export const authService = {
    login: (email: string, pass: string) =>
        signInWithEmailAndPassword(auth, email, pass),

    logout: () => signOut(auth),

    getCurrentUser: () => auth.currentUser,

    getAdminRole: async (uid: string): Promise<'Super Admin' | 'Moderator' | undefined> => {
        const adminDoc = await getDoc(doc(db, 'admins', uid));
        if (adminDoc.exists()) {
            return adminDoc.data().role;
        }
        return undefined;
    }
};
