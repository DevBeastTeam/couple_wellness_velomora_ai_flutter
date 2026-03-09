import React from 'react';
import {
    AppBar,
    Toolbar,
    Typography,
    IconButton,
    Avatar,
    Box,
    Menu,
    MenuItem,
    Tooltip
} from '@mui/material';
import {
    Menu as MenuIcon
} from '@mui/icons-material';
import { useAuth } from '../../contexts/AuthContext';
import { authService } from '../../services/authService';

interface HeaderProps {
    onDrawerToggle: () => void;
}

const Header: React.FC<HeaderProps> = ({ onDrawerToggle }) => {
    const { user, role } = useAuth();

    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

    const handleMenu = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    const handleLogout = async () => {
        await authService.logout();
        handleClose();
    };

    return (
        <AppBar
            position="fixed"
            sx={{
                zIndex: (theme) => theme.zIndex.drawer + 1,
                backgroundColor: 'white',
                color: '#1E293B',
                boxShadow: 'none',
                borderBottom: '1px solid #E2E8F0'
            }}
        >
            <Toolbar>
                <IconButton
                    color="inherit"
                    edge="start"
                    onClick={onDrawerToggle}
                    sx={{ mr: 1, display: { xs: 'inline-flex', sm: 'none' } }}
                >
                    <MenuIcon />
                </IconButton>

                <Typography variant="h6" noWrap component="div" sx={{ flexGrow: 1, fontWeight: 'bold' }}>
                    Admin Panel
                </Typography>

                <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>

                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                        <Box sx={{ textAlign: 'right', display: { xs: 'none', sm: 'block' } }}>
                            <Typography variant="body2" sx={{ fontWeight: '600' }}>
                                {user?.displayName || 'Admin User'}
                            </Typography>
                            <Typography variant="caption" color="text.secondary">
                                {role || 'Moderator'}
                            </Typography>
                        </Box>
                        <Tooltip title="Account settings">
                            <IconButton onClick={handleMenu} sx={{ p: 0 }}>
                                <Avatar sx={{ bgcolor: '#7C3AED' }}>
                                    {user?.email?.charAt(0).toUpperCase()}
                                </Avatar>
                            </IconButton>
                        </Tooltip>
                        <Menu
                            anchorEl={anchorEl}
                            open={Boolean(anchorEl)}
                            onClose={handleClose}
                            transformOrigin={{ horizontal: 'right', vertical: 'top' }}
                            anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
                        >
                            <MenuItem onClick={handleClose}>Profile</MenuItem>
                            <MenuItem onClick={handleLogout}>Logout</MenuItem>
                        </Menu>
                    </Box>
                </Box>
            </Toolbar>
        </AppBar>
    );
};

export default Header;
