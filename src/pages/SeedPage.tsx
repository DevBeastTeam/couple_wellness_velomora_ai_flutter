import React, { useState } from 'react';
import {
    Box,
    Typography,
    Button,
    Paper,
    List,
    ListItem,
    ListItemIcon,
    ListItemText,
    CircularProgress,
    Alert
} from '@mui/material';
import { CheckCircle, Storage, PersonAdd } from '@mui/icons-material';
import { seedService } from '../services/seedService';

const SeedPage: React.FC = () => {
    const [logs, setLogs] = useState<string[]>([]);
    const [loading, setLoading] = useState(false);
    const [complete, setComplete] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const addLog = (msg: string) => {
        setLogs(prev => [...prev, `${new Date().toLocaleTimeString()}: ${msg}`]);
    };

    const handleSeed = async () => {
        setLoading(true);
        setError(null);
        setLogs([]);
        try {
            addLog('Starting Migration...');
            const adminResult = await seedService.seedAdmin();
            addLog(adminResult.message);

            await seedService.seedDummyData((msg) => addLog(msg));

            setComplete(true);
        } catch (err: any) {
            setError(err.message || 'An error occurred during seeding.');
            addLog(`ERROR: ${err.message}`);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Box sx={{ maxWidth: 800, mx: 'auto', mt: 4 }}>
            <Paper sx={{ p: 4, borderRadius: 3 }}>
                <Typography variant="h4" gutterBottom sx={{ fontWeight: 'bold', display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Storage color="primary" fontSize="large" />
                    Data Migration & Seeding
                </Typography>
                <Typography variant="body1" color="text.secondary" paragraph>
                    This utility will create the initial Super Admin account and populate your Firestore with dummy data for testing.
                </Typography>

                <Alert severity="warning" sx={{ mb: 3 }}>
                    <strong>Admin Credentials:</strong> admin@gmail.com / 12345678
                </Alert>

                <Box sx={{ my: 4, display: 'flex', gap: 2 }}>
                    <Button
                        variant="contained"
                        size="large"
                        onClick={handleSeed}
                        disabled={loading}
                        startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <PersonAdd />}
                    >
                        {loading ? 'Seeding...' : 'Start Seeding'}
                    </Button>
                </Box>

                {logs.length > 0 && (
                    <Box sx={{ mt: 4 }}>
                        <Typography variant="h6" gutterBottom>Process Logs</Typography>
                        <Paper variant="outlined" sx={{ bgcolor: 'grey.50', maxH: 300, overflow: 'auto', p: 2 }}>
                            <List dense>
                                {logs.map((log, i) => (
                                    <ListItem key={i}>
                                        <ListItemIcon sx={{ minWidth: 36 }}>
                                            {log.includes('Complete') || log.includes('successfully') ?
                                                <CheckCircle color="success" fontSize="small" /> :
                                                <CircularProgress size={14} />
                                            }
                                        </ListItemIcon>
                                        <ListItemText primary={log} />
                                    </ListItem>
                                ))}
                            </List>
                        </Paper>
                    </Box>
                )}

                {complete && (
                    <Alert severity="success" sx={{ mt: 3 }}>
                        Seeding complete! You can now log in with the admin credentials.
                    </Alert>
                )}

                {error && (
                    <Alert severity="error" sx={{ mt: 3 }}>
                        {error}
                    </Alert>
                )}
            </Paper>
        </Box>
    );
};

export default SeedPage;
