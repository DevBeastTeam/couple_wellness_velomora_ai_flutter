import React, { useState, useEffect } from 'react';
import { Grid, Typography, Box } from '@mui/material';
import {
    PeopleAlt,
    Star,
    Message,
    Gamepad
} from '@mui/icons-material';
import KPICard from '../../components/Common/KPICard';

const Dashboard: React.FC = () => {
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Simulate data loading
        const timer = setTimeout(() => {
            setLoading(false);
        }, 1500);
        return () => clearTimeout(timer);
    }, []);

    return (
        <Box>
            <Typography variant="h5" sx={{ mb: 3, fontWeight: 'bold' }}>
                Dashboard Overview
            </Typography>

            <Grid container spacing={3}>
                <Grid item xs={12} sm={6} md={3}>
                    <KPICard
                        title="Total Users"
                        value="12,543"
                        icon={<PeopleAlt />}
                        trend={{ value: 12, isUp: true }}
                        loading={loading}
                    />
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <KPICard
                        title="Premium Subs"
                        value="1,245"
                        icon={<Star />}
                        trend={{ value: 5, isUp: true }}
                        loading={loading}
                        color="#F59E0B"
                    />
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <KPICard
                        title="AI Messages"
                        value="45,678"
                        icon={<Message />}
                        trend={{ value: 8, isUp: false }}
                        loading={loading}
                        color="#10B981"
                    />
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <KPICard
                        title="Total Games"
                        value="8,921"
                        icon={<Gamepad />}
                        trend={{ value: 15, isUp: true }}
                        loading={loading}
                        color="#3B82F6"
                    />
                </Grid>
            </Grid>

            {/* Charts section will go here */}
            <Box sx={{ mt: 4 }}>
                <Typography variant="h6" sx={{ mb: 2 }}>
                    User Growth
                </Typography>
                <Box sx={{ height: 300, bgcolor: 'white', borderRadius: 2, p: 2, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <Typography color="text.secondary italic">
                        Charts implementation following Recharts setup...
                    </Typography>
                </Box>
            </Box>
        </Box>
    );
};

export default Dashboard;
