import React, { createContext, useContext, useEffect, useState } from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '../services/firebase';
import { authService, AdminUser } from '../services/authService';

interface AuthContextType {
    user: AdminUser | null;
    loading: boolean;
    role: 'Super Admin' | 'Moderator' | null;
}

const AuthContext = createContext<AuthContextType>({
    user: null,
    loading: true,
    role: null,
});

export const useAuth = () => useContext(AuthContext);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [user, setUser] = useState<AdminUser | null>(null);
    const [loading, setLoading] = useState(true);
    const [role, setRole] = useState<'Super Admin' | 'Moderator' | null>(null);

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
            if (firebaseUser) {
                const adminRole = await authService.getAdminRole(firebaseUser.uid);
                setUser({ ...firebaseUser } as AdminUser);
                setRole(adminRole || null);
            } else {
                setUser(null);
                setRole(null);
            }
            setLoading(false);
        });

        return unsubscribe;
    }, []);

    return (
        <AuthContext.Provider value={{ user, loading, role }}>
            {loading ? (
                <div className="flex h-screen w-full items-center justify-center bg-slate-50 dark:bg-slate-900">
                    <div className="text-center">
                        <div className="h-12 w-12 animate-spin rounded-full border-4 border-primary border-t-transparent mx-auto"></div>
                        <p className="mt-4 font-medium text-slate-600 dark:text-slate-400">Initializing Velmora Admin...</p>
                    </div>
                </div>
            ) : (
                children
            )}
        </AuthContext.Provider>
    );
};
