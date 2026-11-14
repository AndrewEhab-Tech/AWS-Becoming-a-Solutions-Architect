const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/api/auth/health', (req, res) => {
    res.json({ service: 'auth-service', status: 'UP', timestamp: new Date().toISOString() });
});

app.post('/api/auth/login', (req, res) => {
    res.json({ token: 'mock-jwt-token-fargate-saa', expires_in: 3600 });
});

app.listen(port, () => console.log(`Auth service running on port ${port}`));
