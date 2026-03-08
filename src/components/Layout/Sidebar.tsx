import React from 'react';
import {
    Drawer,
    List,
    ListItem,
    ListItemIcon,
    ListItemText,
    ListItemButton,
    Toolbar,
    Typography,
    Box
} from '@mui/material';
import {
    Dashboard as DashboardIcon,
    People as PeopleIcon,
    Subscriptions as SubscriptionsIcon,
    SmartToy as SmartToyIcon,
    SportsEsports as GamesIcon,
    FitnessCenter as KegelIcon,
    Notifications as NotifyIcon,
    SupportAgent as SupportIcon,
    Article as ContentIcon,
    Assessment as AnalyticsIcon,
    Settings as SettingsIcon
} from '@mui/icons-material';
import { useNavigate, useLocation } from 'react-router-dom';

const drawerWidth = 260;

const menuItems = [
    { text: 'Dashboard', icon: <DashboardIcon />, path: '/' },
    { text: 'Users', icon: <PeopleIcon />, path: '/users' },
    { text: 'Subscriptions', icon: <SubscriptionsIcon />, path: '/subscriptions' },
    { text: 'AI Configuration', icon: <SmartToyIcon />, path: '/ai-config' },
    { text: 'Games', icon: <GamesIcon />, path: '/games' },
    { text: 'Kegel Exercises', icon: <KegelIcon />, path: '/kegel' },
    { text: 'Notifications', icon: <NotifyIcon />, path: '/notifications' },
    { text: 'Support', icon: <SupportIcon />, path: '/support' },
    { text: 'Content', icon: <ContentIcon />, path: '/content' },
    { text: 'Analytics', icon: <AnalyticsIcon />, path: '/analytics' },
    { text: 'Settings', icon: <SettingsIcon />, path: '/settings' },
];

const Sidebar: React.FC = () => {
    const navigate = useNavigate();
    const location = useLocation();

    return (
        <Drawer
            variant="permanent"
            sx={{
                width: drawerWidth,
                flexShrink: 0,
                [`& .MuiDrawer-paper`]: {
                    width: drawerWidth,
                    boxSizing: 'border-box',
                    backgroundColor: '#1E1B4B', // indigo-950
                    color: 'white'
                },
            }}
        >
            <Toolbar>
                <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 'bold', color: '#A78BFA' }}>
                    Velmora Admin
                </Typography>
            </Toolbar>
            <Box sx={{ overflow: 'auto' }}>
                <List>
                    {menuItems.map((item) => (
                        <ListItem key={item.text} disablePadding>
                            <ListItemButton
                                onClick={() => navigate(item.path)}
                                selected={location.pathname === item.path}
                                sx={{
                                    '&.Mui-selected': {
                                        backgroundColor: 'rgba(124, 58, 237, 0.2)',
                                        borderRight: '4px solid #7C3AED',
                                    },
                                    '&:hover': {
                                        backgroundColor: 'rgba(124, 58, 237, 0.1)',
                                    },
                                    color: location.pathname === item.path ? '#A78BFA' : 'rgba(255,255,255,0.7)',
                                    '& .MuiListItemIcon-root': {
                                        color: location.pathname === item.path ? '#7C3AED' : 'rgba(255,255,255,0.7)',
                                    }
                                }}
                            >
                                <ListItemIcon>
                                    {item.icon}
                                </ListItemIcon>
                                <ListItemText primary={item.text} />
                            </ListItemButton>
                        </ListItem>
                    ))}
                </List>
            </Box>
        </Drawer>
    );
};

export default Sidebar;
