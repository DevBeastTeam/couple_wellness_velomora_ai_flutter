import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Avatar,
    Chip,
    IconButton,
    TextField,
    InputAdornment,
    CircularProgress,
    Switch,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    Button,
    Alert
} from '@mui/material';
import {
    Search,
    Visibility,
    FilterList,
    Delete,
    Block,
    CheckCircle
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { userService, UserProfile } from '../../services/userService';

const UserListPage: React.FC = () => {
    const [users, setUsers] = useState<UserProfile[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState<UserProfile | null>(null);
    const [success, setSuccess] = useState<string | null>(null);
    const [error, setError] = useState<string | null>(null);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchUsers = async () => {
            try {
                const data = await userService.getUsers(50);
                setUsers(data);
            } catch (error) {
                console.error('Error fetching users:', error);
            } finally {
                setLoading(false);
            }
        };
        fetchUsers();
    }, []);

    const filteredUsers = users.filter(user =>
        user.displayName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.email?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const getStatusChip = (status: string) => {
        switch (status) {
            case 'premium': return <Chip label="Premium" color="primary" size="small" />;
            case 'trial': return <Chip label="Trial" color="warning" size="small" />;
            default: return <Chip label="Free" color="default" size="small" />;
        }
    };

    const handleBanToggle = async (user: UserProfile) => {
        try {
            const newBanStatus = !user.isBanned;
            await userService.updateUser(user.uid, { isBanned: newBanStatus });
            setSuccess(newBanStatus ? 'User banned successfully!' : 'User unbanned successfully!');
            // Refresh users
            const data = await userService.getUsers(50);
            setUsers(data);
        } catch (err: any) {
            setError(err.message || 'Failed to update ban status');
        }
    };

    const handleDeleteClick = (user: UserProfile) => {
        setSelectedUser(user);
        setDeleteDialogOpen(true);
    };

    const handleDeleteConfirm = async () => {
        if (!selectedUser) return;
        try {
            await userService.deleteUser(selectedUser.uid);
            setSuccess('User deleted successfully!');
            setDeleteDialogOpen(false);
            // Refresh users
            const data = await userService.getUsers(50);
            setUsers(data);
        } catch (err: any) {
            setError(err.message || 'Failed to delete user');
        }
    };

    return (
        <Box>
            {success && <Alert severity="success" onClose={() => setSuccess(null)} sx={{ mb: 3 }}>{success}</Alert>}
            {error && <Alert severity="error" onClose={() => setError(null)} sx={{ mb: 3 }}>{error}</Alert>}

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
                <Typography variant="h5" sx={{ fontWeight: 'bold' }}>User Management</Typography>
                <Box sx={{ display: 'flex', gap: 2 }}>
                    <TextField
                        variant="outlined"
                        size="small"
                        placeholder="Search users..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        InputProps={{
                            startAdornment: (
                                <InputAdornment position="start">
                                    <Search fontSize="small" />
                                </InputAdornment>
                            ),
                        }}
                        sx={{ bgcolor: 'white', borderRadius: 1, width: 300 }}
                    />
                    <IconButton sx={{ bgcolor: 'white', border: '1px solid #E2E8F0' }}>
                        <FilterList />
                    </IconButton>
                </Box>
            </Box>

            <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}>
                <Table sx={{ minWidth: 650 }}>
                    <TableHead sx={{ bgcolor: '#F8FAFC' }}>
                        <TableRow>
                            <TableCell sx={{ fontWeight: '600' }}>User</TableCell>
                            <TableCell sx={{ fontWeight: '600' }}>Status</TableCell>
                            <TableCell sx={{ fontWeight: '600' }}>Plan Expiry</TableCell>
                            <TableCell sx={{ fontWeight: '600' }}>Language</TableCell>
                            <TableCell sx={{ fontWeight: '600' }}>Created</TableCell>
                            <TableCell sx={{ fontWeight: '600' }}>Ban/Unban</TableCell>
                            <TableCell align="right" sx={{ fontWeight: '600' }}>Actions</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loading ? (
                            <TableRow>
                                <TableCell colSpan={7} align="center" sx={{ py: 3 }}>
                                    <CircularProgress size={30} />
                                </TableCell>
                            </TableRow>
                        ) : filteredUsers.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={7} align="center" sx={{ py: 3 }}>
                                    <Typography color="text.secondary">No users found</Typography>
                                </TableCell>
                            </TableRow>
                        ) : (
                            filteredUsers.map((user) => (
                                <TableRow key={user.uid} hover sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                                    <TableCell>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                                            <Avatar src={user.photoURL} sx={{ bgcolor: '#7C3AED' }}>
                                                {user.displayName?.charAt(0) || user.email.charAt(0)}
                                            </Avatar>
                                            <Box>
                                                <Typography variant="body2" sx={{ fontWeight: '600' }}>{user.displayName || 'N/A'}</Typography>
                                                <Typography variant="caption" color="text.secondary">{user.email}</Typography>
                                            </Box>
                                        </Box>
                                    </TableCell>
                                    <TableCell>
                                        {user.isBanned ? (
                                            <Chip label="BANNED" color="error" size="small" />
                                        ) : (
                                            getStatusChip(user.subscriptionStatus)
                                        )}
                                    </TableCell>
                                    <TableCell>
                                        <Box>
                                            {user.subscriptionExpiryDate?.seconds ? (
                                                <>
                                                    <Typography variant="body2" sx={{ fontWeight: '600' }}>
                                                        {new Date(user.subscriptionExpiryDate.seconds * 1000).toLocaleDateString()}
                                                    </Typography>
                                                    <Typography variant="caption" color="text.secondary">
                                                        {user.subscriptionType?.includes('monthly') ? 'Monthly' :
                                                         user.subscriptionType?.includes('quarterly') ? 'Quarterly' :
                                                         user.subscriptionType?.includes('yearly') ? 'Yearly' : 'Premium'}
                                                    </Typography>
                                                </>
                                            ) : (
                                                <Typography variant="body2" color="text.secondary">
                                                    No expiry (Free)
                                                </Typography>
                                            )}
                                        </Box>
                                    </TableCell>
                                    <TableCell>
                                        <Typography variant="body2">{user.preferredLanguage.toUpperCase()}</Typography>
                                    </TableCell>
                                    <TableCell>
                                        <Typography variant="body2">
                                            {user.createdAt?.seconds ? new Date(user.createdAt.seconds * 1000).toLocaleDateString() : 'N/A'}
                                        </Typography>
                                    </TableCell>
                                    <TableCell>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                            <Switch
                                                checked={!user.isBanned}
                                                onChange={() => handleBanToggle(user)}
                                                color={user.isBanned ? 'error' : 'success'}
                                                size="small"
                                            />
                                            <Typography variant="caption" color="text.secondary">
                                                {user.isBanned ? 'Banned' : 'Active'}
                                            </Typography>
                                        </Box>
                                    </TableCell>
                                    <TableCell align="right">
                                        <IconButton
                                            size="small"
                                            color="primary"
                                            onClick={() => navigate(`/users/${user.uid}`)}
                                            title="View Details"
                                        >
                                            <Visibility fontSize="small" />
                                        </IconButton>
                                        <IconButton
                                            size="small"
                                            color="error"
                                            onClick={() => handleDeleteClick(user)}
                                            title="Delete User"
                                        >
                                            <Delete fontSize="small" />
                                        </IconButton>
                                    </TableCell>
                                </TableRow>
                            ))
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            {/* Delete Dialog */}
            <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)} maxWidth="sm" fullWidth>
                <DialogTitle>Delete User Account</DialogTitle>
                <DialogContent>
                    <Alert severity="error" sx={{ mb: 2 }}>
                        This action cannot be undone!
                    </Alert>
                    <Typography>
                        Are you sure you want to delete <strong>{selectedUser?.displayName || selectedUser?.email}</strong>? All user data will be permanently removed.
                    </Typography>
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>
                    <Button onClick={handleDeleteConfirm} variant="contained" color="error">
                        Delete Account
                    </Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};

export default UserListPage;
