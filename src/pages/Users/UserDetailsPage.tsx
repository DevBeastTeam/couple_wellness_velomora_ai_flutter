import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Grid,
    Avatar,
    Divider,
    Button,
    CircularProgress,
    Card,
    CardContent,
    Chip,
    IconButton,
    Breadcrumbs,
    Link
} from '@mui/material';
import {
    ArrowBack,
    Mail,
    CalendarToday,
    Language,
    VerifiedUser,
    History,
    Edit
} from '@mui/icons-material';
import { useParams, useNavigate, Link as RouterLink } from 'react-router-dom';
import { userService, UserProfile } from '../../services/userService';

const UserDetailsPage: React.FC = () => {
    const { uid } = useParams<{ uid: string }>();
    const [user, setUser] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchUser = async () => {
            if (!uid) return;
            try {
                const data = await userService.getUserById(uid);
                setUser(data);
            } catch (error) {
                console.error('Error fetching user details:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchUser();
    }, [uid]);

    if (loading) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
                <CircularProgress />
            </Box>
        );
    }

    if (!user) {
        return (
            <Box sx={{ p: 4, textAlign: 'center' }}>
                <Typography variant="h6" color="error">User not found</Typography>
                <Button onClick={() => navigate('/users')} startIcon={<ArrowBack />} sx={{ mt: 2 }}>
                    Back to Users
                </Button>
            </Box>
        );
    }

    return (
        <Box>
            <Box sx={{ mb: 3 }}>
                <Breadcrumbs sx={{ mb: 2 }}>
                    <Link component={RouterLink} underline="hover" color="inherit" to="/">Dashboard</Link>
                    <Link component={RouterLink} underline="hover" color="inherit" to="/users">Users</Link>
                    <Typography color="text.primary">Details</Typography>
                </Breadcrumbs>

                <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <IconButton onClick={() => navigate('/users')} size="small">
                        <ArrowBack />
                    </IconButton>
                    <Typography variant="h5" sx={{ fontWeight: 'bold' }}>User Details</Typography>
                </Box>
            </Box>

            <Grid container spacing={3}>
                {/* Profile Overview */}
                <Grid item xs={12} md={4}>
                    <Card sx={{ borderRadius: 3, textAlign: 'center', py: 2 }}>
                        <CardContent>
                            <Avatar
                                src={user.photoURL}
                                sx={{ width: 100, height: 100, mx: 'auto', mb: 2, bgcolor: '#7C3AED', fontSize: '2rem' }}
                            >
                                {user.displayName?.charAt(0) || user.email.charAt(0)}
                            </Avatar>
                            <Typography variant="h6" sx={{ fontWeight: 'bold' }}>{user.displayName || 'Unnamed User'}</Typography>
                            <Typography color="text.secondary" gutterBottom>{user.email}</Typography>
                            <Box sx={{ mt: 2 }}>
                                <Chip
                                    label={user.subscriptionStatus.toUpperCase()}
                                    color={user.subscriptionStatus === 'premium' ? 'primary' : 'default'}
                                    sx={{ width: 100 }}
                                />
                            </Box>
                        </CardContent>
                        <Divider sx={{ my: 1 }} />
                        <Box sx={{ p: 2 }}>
                            <Button fullWidth variant="outlined" startIcon={<Edit />}>Edit Profile</Button>
                        </Box>
                    </Card>
                </Grid>

                {/* User Stats & Info */}
                <Grid item xs={12} md={8}>
                    <Grid container spacing={3}>
                        <Grid item xs={12}>
                            <Paper sx={{ p: 3, borderRadius: 3 }}>
                                <Typography variant="h6" gutterBottom sx={{ fontWeight: '600' }}>Account Information</Typography>
                                <Grid container spacing={2}>
                                    <Grid item xs={12} sm={6}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                                            <Mail color="action" />
                                            <Box>
                                                <Typography variant="caption" color="text.secondary">Email Address</Typography>
                                                <Typography variant="body2">{user.email}</Typography>
                                            </Box>
                                        </Box>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                                            <CalendarToday color="action" />
                                            <Box>
                                                <Typography variant="caption" color="text.secondary">Member Since</Typography>
                                                <Typography variant="body2">
                                                    {user.createdAt?.seconds ? new Date(user.createdAt.seconds * 1000).toLocaleDateString() : 'N/A'}
                                                </Typography>
                                            </Box>
                                        </Box>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                                            <Language color="action" />
                                            <Box>
                                                <Typography variant="caption" color="text.secondary">Preferred Language</Typography>
                                                <Typography variant="body2">{user.preferredLanguage.toUpperCase()}</Typography>
                                            </Box>
                                        </Box>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                                            <History color="action" />
                                            <Box>
                                                <Typography variant="caption" color="text.secondary">Last Login</Typography>
                                                <Typography variant="body2">
                                                    {user.lastLoginAt?.seconds ? new Date(user.lastLoginAt.seconds * 1000).toLocaleString() : 'N/A'}
                                                </Typography>
                                            </Box>
                                        </Box>
                                    </Grid>
                                </Grid>
                            </Paper>
                        </Grid>

                        <Grid item xs={12}>
                            <Paper sx={{ p: 3, borderRadius: 3 }}>
                                <Typography variant="h6" gutterBottom sx={{ fontWeight: '600' }}>Features Access</Typography>
                                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
                                    {user.featuresAccess ? Object.entries(user.featuresAccess).map(([key, val]) => (
                                        <Chip
                                            key={key}
                                            icon={<VerifiedUser />}
                                            label={key.charAt(0).toUpperCase() + key.slice(1)}
                                            color={val ? 'success' : 'default'}
                                            variant="outlined"
                                        />
                                    )) : <Typography color="text.secondary">No features defined</Typography>}
                                </Box>
                            </Paper>
                        </Grid>
                    </Grid>
                </Grid>
            </Grid >
        </Box >
    );
};

export default UserDetailsPage;
