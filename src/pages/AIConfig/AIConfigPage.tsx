import React, { useState, useEffect } from 'react';
import {
    Box, Typography, TextField, Button, Paper, Grid,
    CircularProgress, Alert, MenuItem, Divider, InputAdornment, IconButton
} from '@mui/material';
import { Save, Refresh, Visibility, VisibilityOff } from '@mui/icons-material';
import { doc, getDoc, setDoc, serverTimestamp } from 'firebase/firestore';
import { db } from '../../services/firebase';

interface SafetySettings {
    dangerousContent: string;
    harassment: string;
    hateSpeech: string;
    sexuallyExplicit: string;
}

interface AIConfig {
    apiKey: string;
    maxTokens: number;
    model: string;
    safetySettings: SafetySettings;
    systemInstruction: string;
    temperature: number;
    topK: number;
    topP: number;
}

const defaultConfig: AIConfig = {
    apiKey: 'PLACEHOLDER_KEY',
    maxTokens: 500,
    model: 'gemini-2.0-flash',
    safetySettings: {
        dangerousContent: 'BLOCK_MEDIUM_AND_ABOVE',
        harassment: 'BLOCK_MEDIUM_AND_ABOVE',
        hateSpeech: 'BLOCK_MEDIUM_AND_ABOVE',
        sexuallyExplicit: 'BLOCK_MEDIUM_AND_ABOVE',
    },
    systemInstruction: 'You are Velmora AI, a helpful relationship coach.',
    temperature: 0.7,
    topK: 40,
    topP: 0.95,
};

const safetyLevels = [
    'BLOCK_NONE',
    'BLOCK_ONLY_HIGH',
    'BLOCK_MEDIUM_AND_ABOVE',
    'BLOCK_LOW_AND_ABOVE',
];

const AIConfigPage: React.FC = () => {
    const [config, setConfig] = useState<AIConfig>(defaultConfig);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [success, setSuccess] = useState<string | null>(null);
    const [error, setError] = useState<string | null>(null);
    const [showApiKey, setShowApiKey] = useState(false);

    useEffect(() => {
        loadConfig();
    }, []);

    const loadConfig = async () => {
        setLoading(true);
        try {
            const docRef = doc(db, 'ai_config', 'settings');
            const docSnap = await getDoc(docRef);

            if (docSnap.exists()) {
                setConfig(docSnap.data() as AIConfig);
            } else {
                setConfig(defaultConfig);
            }
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    };

    const handleSave = async () => {
        setSaving(true);
        setSuccess(null);
        setError(null);

        try {
            const docRef = doc(db, 'ai_config', 'settings');
            await setDoc(docRef, {
                ...config,
                updatedAt: serverTimestamp(),
            });
            setSuccess('AI configuration saved successfully!');
        } catch (e: any) {
            setError(e.message);
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '400px' }}>
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Box>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
                <Typography variant="h5" sx={{ fontWeight: 'bold' }}>AI Configuration</Typography>
                <Button
                    variant="outlined"
                    startIcon={<Refresh />}
                    onClick={loadConfig}
                >
                    Refresh
                </Button>
            </Box>

            {success && <Alert severity="success" onClose={() => setSuccess(null)} sx={{ mb: 3 }}>{success}</Alert>}
            {error && <Alert severity="error" onClose={() => setError(null)} sx={{ mb: 3 }}>{error}</Alert>}

            <Paper sx={{ p: 4, borderRadius: 3 }}>
                <Grid container spacing={3}>
                    {/* API Key */}
                    <Grid item xs={12}>
                        <Typography variant="h6" gutterBottom>API Configuration</Typography>
                        <Divider sx={{ mb: 2 }} />
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            label="API Key"
                            value={config.apiKey}
                            onChange={(e) => setConfig({ ...config, apiKey: e.target.value })}
                            helperText="Your Gemini API key"
                            type={showApiKey ? 'text' : 'password'}
                            InputProps={{
                                endAdornment: (
                                    <InputAdornment position="end">
                                        <IconButton
                                            onClick={() => setShowApiKey(!showApiKey)}
                                            edge="end"
                                        >
                                            {showApiKey ? <VisibilityOff /> : <Visibility />}
                                        </IconButton>
                                    </InputAdornment>
                                ),
                            }}
                        />
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            label="Model"
                            value={config.model}
                            onChange={(e) => setConfig({ ...config, model: e.target.value })}
                            helperText="Gemini model to use"
                        />
                    </Grid>

                    {/* Generation Parameters */}
                    <Grid item xs={12} sx={{ mt: 3 }}>
                        <Typography variant="h6" gutterBottom>Generation Parameters</Typography>
                        <Divider sx={{ mb: 2 }} />
                    </Grid>

                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            type="number"
                            label="Max Tokens"
                            value={config.maxTokens}
                            onChange={(e) => setConfig({ ...config, maxTokens: Number(e.target.value) })}
                            helperText="Maximum output tokens"
                            inputProps={{ min: 1, max: 8192 }}
                        />
                    </Grid>

                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            type="number"
                            label="Temperature"
                            value={config.temperature}
                            onChange={(e) => setConfig({ ...config, temperature: Number(e.target.value) })}
                            helperText="0.0 - 2.0"
                            inputProps={{ min: 0, max: 2, step: 0.1 }}
                        />
                    </Grid>

                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            type="number"
                            label="Top K"
                            value={config.topK}
                            onChange={(e) => setConfig({ ...config, topK: Number(e.target.value) })}
                            helperText="1 - 100"
                            inputProps={{ min: 1, max: 100 }}
                        />
                    </Grid>

                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            type="number"
                            label="Top P"
                            value={config.topP}
                            onChange={(e) => setConfig({ ...config, topP: Number(e.target.value) })}
                            helperText="0.0 - 1.0"
                            inputProps={{ min: 0, max: 1, step: 0.05 }}
                        />
                    </Grid>

                    {/* Safety Settings */}
                    <Grid item xs={12} sx={{ mt: 3 }}>
                        <Typography variant="h6" gutterBottom>Safety Settings</Typography>
                        <Divider sx={{ mb: 2 }} />
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            select
                            label="Dangerous Content"
                            value={config.safetySettings.dangerousContent}
                            onChange={(e) => setConfig({
                                ...config,
                                safetySettings: { ...config.safetySettings, dangerousContent: e.target.value }
                            })}
                        >
                            {safetyLevels.map((level) => (
                                <MenuItem key={level} value={level}>{level}</MenuItem>
                            ))}
                        </TextField>
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            select
                            label="Harassment"
                            value={config.safetySettings.harassment}
                            onChange={(e) => setConfig({
                                ...config,
                                safetySettings: { ...config.safetySettings, harassment: e.target.value }
                            })}
                        >
                            {safetyLevels.map((level) => (
                                <MenuItem key={level} value={level}>{level}</MenuItem>
                            ))}
                        </TextField>
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            select
                            label="Hate Speech"
                            value={config.safetySettings.hateSpeech}
                            onChange={(e) => setConfig({
                                ...config,
                                safetySettings: { ...config.safetySettings, hateSpeech: e.target.value }
                            })}
                        >
                            {safetyLevels.map((level) => (
                                <MenuItem key={level} value={level}>{level}</MenuItem>
                            ))}
                        </TextField>
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <TextField
                            fullWidth
                            select
                            label="Sexually Explicit"
                            value={config.safetySettings.sexuallyExplicit}
                            onChange={(e) => setConfig({
                                ...config,
                                safetySettings: { ...config.safetySettings, sexuallyExplicit: e.target.value }
                            })}
                        >
                            {safetyLevels.map((level) => (
                                <MenuItem key={level} value={level}>{level}</MenuItem>
                            ))}
                        </TextField>
                    </Grid>

                    {/* System Instruction */}
                    <Grid item xs={12} sx={{ mt: 3 }}>
                        <Typography variant="h6" gutterBottom>System Instruction</Typography>
                        <Divider sx={{ mb: 2 }} />
                    </Grid>

                    <Grid item xs={12}>
                        <TextField
                            fullWidth
                            multiline
                            rows={6}
                            label="System Instruction"
                            value={config.systemInstruction}
                            onChange={(e) => setConfig({ ...config, systemInstruction: e.target.value })}
                            helperText="The AI's role and behavior instructions"
                        />
                    </Grid>

                    {/* Save Button */}
                    <Grid item xs={12} sx={{ mt: 2 }}>
                        <Button
                            variant="contained"
                            size="large"
                            startIcon={saving ? <CircularProgress size={20} color="inherit" /> : <Save />}
                            onClick={handleSave}
                            disabled={saving}
                            sx={{ minWidth: 200 }}
                        >
                            {saving ? 'Saving...' : 'Save Configuration'}
                        </Button>
                    </Grid>
                </Grid>
            </Paper>
        </Box>
    );
};

export default AIConfigPage;
