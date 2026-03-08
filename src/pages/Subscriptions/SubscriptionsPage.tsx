import React, { useState, useEffect } from 'react';
import {
    Box, Typography, Button, Paper, Grid, TextField, Switch,
    FormControlLabel, IconButton, Dialog, DialogTitle, DialogContent,
    DialogActions, Chip, Divider, CircularProgress, Alert
} from '@mui/material';
import {
    Add, Edit, Delete, Refresh, Star, Check
} from '@mui/icons-material';
import { subscriptionPlanService, SubscriptionPlan } from '../../services/subscriptionPlanService';

const defaultPlan: Omit<SubscriptionPlan, 'id'> = {
    name: '',
    productId: '',
    durationMonths: 1,
    pricePerMonth: 0,
    totalPrice: 0,
    currency: 'USD',
    badge: '',
    badgeColor: '#FF8A00',
    savingsText: '',
    features: [],
    isActive: true,
    isPopular: false,
    sortOrder: 99,
};

const SubscriptionsPage: React.FC = () => {
    const [plans, setPlans] = useState<SubscriptionPlan[]>([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [editingPlan, setEditingPlan] = useState<Partial<SubscriptionPlan>>(defaultPlan);
    const [isEditing, setIsEditing] = useState(false);
    const [saving, setSaving] = useState(false);
    const [seeding, setSeeding] = useState(false);
    const [featureInput, setFeatureInput] = useState('');
    const [success, setSuccess] = useState<string | null>(null);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => { fetchPlans(); }, []);

    const fetchPlans = async () => {
        setLoading(true);
        try {
            setPlans(await subscriptionPlanService.getPlans());
        } catch (e: any) { setError(e.message); }
        finally { setLoading(false); }
    };

    const openCreateDialog = () => {
        setEditingPlan({ ...defaultPlan });
        setIsEditing(false);
        setFeatureInput('');
        setDialogOpen(true);
    };

    const openEditDialog = (plan: SubscriptionPlan) => {
        setEditingPlan({ ...plan });
        setIsEditing(true);
        setFeatureInput('');
        setDialogOpen(true);
    };

    const handleSave = async () => {
        setSaving(true);
        try {
            if (isEditing && editingPlan.id) {
                await subscriptionPlanService.updatePlan(editingPlan.id, editingPlan);
                setSuccess('Plan updated successfully!');
            } else {
                await subscriptionPlanService.createPlan(editingPlan as Omit<SubscriptionPlan, 'id'>);
                setSuccess('Plan created successfully!');
            }
            setDialogOpen(false);
            await fetchPlans();
        } catch (e: any) {
            setError(e.message);
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (id: string) => {
        if (!window.confirm('Delete this plan?')) return;
        await subscriptionPlanService.deletePlan(id);
        await fetchPlans();
    };

    const handleSeedDefaults = async () => {
        setSeeding(true);
        await subscriptionPlanService.seedDefaultPlans();
        setSuccess('Default plans seeded to Firestore!');
        await fetchPlans();
        setSeeding(false);
    };

    const addFeature = () => {
        if (!featureInput.trim()) return;
        setEditingPlan(prev => ({ ...prev, features: [...(prev.features || []), featureInput.trim()] }));
        setFeatureInput('');
    };

    const removeFeature = (i: number) => {
        setEditingPlan(prev => ({ ...prev, features: prev.features?.filter((_, idx) => idx !== i) }));
    };

    return (
        <Box>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
                <Typography variant="h5" sx={{ fontWeight: 'bold' }}>Subscription Plans</Typography>
                <Box sx={{ display: 'flex', gap: 2 }}>
                    {plans.length === 0 && (
                        <Button
                            variant="outlined"
                            startIcon={seeding ? <CircularProgress size={16} /> : <Refresh />}
                            onClick={handleSeedDefaults}
                            disabled={seeding}
                        >
                            Seed Default Plans
                        </Button>
                    )}
                    <Button variant="contained" startIcon={<Add />} onClick={openCreateDialog}>
                        Add Plan
                    </Button>
                </Box>
            </Box>

            {success && <Alert severity="success" onClose={() => setSuccess(null)} sx={{ mb: 3 }}>{success}</Alert>}
            {error && <Alert severity="error" onClose={() => setError(null)} sx={{ mb: 3 }}>{error}</Alert>}

            {/* Plans at-a-glance cards */}
            <Grid container spacing={3} sx={{ mb: 4 }}>
                {plans.map(plan => (
                    <Grid item xs={12} sm={6} md={4} key={plan.id}>
                        <Paper
                            sx={{
                                p: 3, borderRadius: 3, position: 'relative',
                                border: plan.isPopular ? '2px solid #7C3AED' : '1px solid #E2E8F0',
                                transition: 'all 0.2s',
                                '&:hover': { boxShadow: '0 10px 25px rgba(0,0,0,0.1)' }
                            }}
                        >
                            {plan.isPopular && (
                                <Chip icon={<Star sx={{ fontSize: '14px !important' }} />} label="Popular" size="small" color="primary" sx={{ position: 'absolute', top: -12, right: 16 }} />
                            )}
                            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
                                <Box>
                                    <Typography variant="h6" fontWeight="bold">{plan.name}</Typography>
                                    {plan.badge && <Chip label={plan.badge} size="small" sx={{ bgcolor: plan.badgeColor || '#FF8A00', color: 'white', mt: 0.5 }} />}
                                </Box>
                                <Chip label={plan.isActive ? 'Active' : 'Inactive'} color={plan.isActive ? 'success' : 'default'} size="small" />
                            </Box>

                            <Box sx={{ mb: 2 }}>
                                <Typography variant="h3" fontWeight="bold" color="primary">
                                    ${plan.pricePerMonth}
                                    <Typography component="span" variant="body2" color="text.secondary">/mo</Typography>
                                </Typography>
                                <Typography variant="body2" color="text.secondary">
                                    ${plan.totalPrice} total · {plan.durationMonths} month{plan.durationMonths > 1 ? 's' : ''}
                                </Typography>
                                {plan.savingsText && (
                                    <Typography variant="caption" color="success.main">{plan.savingsText}</Typography>
                                )}
                            </Box>

                            <Divider sx={{ my: 2 }} />

                            <Box sx={{ mb: 2 }}>
                                {plan.features.map((f, i) => (
                                    <Box key={i} sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.5 }}>
                                        <Check sx={{ fontSize: 14, color: 'success.main' }} />
                                        <Typography variant="body2">{f}</Typography>
                                    </Box>
                                ))}
                            </Box>

                            <Typography variant="caption" color="text.secondary" sx={{ fontFamily: 'monospace', bgcolor: 'grey.100', p: 0.5, borderRadius: 1, display: 'block', mb: 2 }}>
                                {plan.productId}
                            </Typography>

                            <Box sx={{ display: 'flex', gap: 1 }}>
                                <Button size="small" variant="outlined" startIcon={<Edit />} onClick={() => openEditDialog(plan)} fullWidth>Edit</Button>
                                <IconButton size="small" color="error" onClick={() => handleDelete(plan.id)} title="Delete">
                                    <Delete fontSize="small" />
                                </IconButton>
                            </Box>
                        </Paper>
                    </Grid>
                ))}
            </Grid>

            {loading && <Box sx={{ textAlign: 'center', py: 4 }}><CircularProgress /></Box>}
            {!loading && plans.length === 0 && (
                <Paper sx={{ p: 6, textAlign: 'center', borderRadius: 3 }}>
                    <Typography variant="h6" color="text.secondary" gutterBottom>No subscription plans yet</Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
                        Click "Seed Default Plans" to create the standard Monthly, Quarterly, and Yearly plans.
                    </Typography>
                    <Button variant="contained" startIcon={<Refresh />} onClick={handleSeedDefaults} disabled={seeding}>
                        Seed Default Plans
                    </Button>
                </Paper>
            )}

            {/* Edit/Create Dialog */}
            <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
                <DialogTitle sx={{ fontWeight: 'bold' }}>{isEditing ? 'Edit Plan' : 'Create New Plan'}</DialogTitle>
                <DialogContent dividers>
                    <Grid container spacing={2}>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Plan Name" value={editingPlan.name || ''} onChange={e => setEditingPlan(p => ({ ...p, name: e.target.value }))} />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Product ID (IAP)" value={editingPlan.productId || ''} onChange={e => setEditingPlan(p => ({ ...p, productId: e.target.value }))} helperText="Must match App Store / Play Store" />
                        </Grid>
                        <Grid item xs={4}>
                            <TextField fullWidth type="number" label="Duration (months)" value={editingPlan.durationMonths || 1} onChange={e => setEditingPlan(p => ({ ...p, durationMonths: Number(e.target.value) }))} />
                        </Grid>
                        <Grid item xs={4}>
                            <TextField fullWidth type="number" label="Price/Month ($)" value={editingPlan.pricePerMonth || 0} onChange={e => setEditingPlan(p => ({ ...p, pricePerMonth: Number(e.target.value) }))} />
                        </Grid>
                        <Grid item xs={4}>
                            <TextField fullWidth type="number" label="Total Price ($)" value={editingPlan.totalPrice || 0} onChange={e => setEditingPlan(p => ({ ...p, totalPrice: Number(e.target.value) }))} />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Badge Text (optional)" placeholder="e.g. Best Value" value={editingPlan.badge || ''} onChange={e => setEditingPlan(p => ({ ...p, badge: e.target.value }))} />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Savings Text (optional)" placeholder="e.g. Save 50% vs monthly" value={editingPlan.savingsText || ''} onChange={e => setEditingPlan(p => ({ ...p, savingsText: e.target.value }))} />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth type="number" label="Sort Order" value={editingPlan.sortOrder || 1} onChange={e => setEditingPlan(p => ({ ...p, sortOrder: Number(e.target.value) }))} />
                        </Grid>
                        <Grid item xs={6}>
                            <Box sx={{ display: 'flex', gap: 2, mt: 1 }}>
                                <FormControlLabel control={<Switch checked={editingPlan.isActive ?? true} onChange={e => setEditingPlan(p => ({ ...p, isActive: e.target.checked }))} />} label="Active" />
                                <FormControlLabel control={<Switch checked={editingPlan.isPopular ?? false} onChange={e => setEditingPlan(p => ({ ...p, isPopular: e.target.checked }))} />} label="Popular" />
                            </Box>
                        </Grid>
                        <Grid item xs={12}>
                            <Typography variant="subtitle2" gutterBottom>Features</Typography>
                            <Box sx={{ display: 'flex', gap: 1, mb: 1 }}>
                                <TextField size="small" fullWidth placeholder="Add a feature..." value={featureInput} onChange={e => setFeatureInput(e.target.value)} onKeyDown={e => e.key === 'Enter' && addFeature()} />
                                <Button variant="outlined" onClick={addFeature}>Add</Button>
                            </Box>
                            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                                {(editingPlan.features || []).map((f, i) => (
                                    <Chip key={i} label={f} onDelete={() => removeFeature(i)} size="small" />
                                ))}
                            </Box>
                        </Grid>
                    </Grid>
                </DialogContent>
                <DialogActions sx={{ p: 2 }}>
                    <Button onClick={() => setDialogOpen(false)}>Cancel</Button>
                    <Button variant="contained" onClick={handleSave} disabled={saving}>
                        {saving ? <CircularProgress size={20} /> : isEditing ? 'Update Plan' : 'Create Plan'}
                    </Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};

export default SubscriptionsPage;
