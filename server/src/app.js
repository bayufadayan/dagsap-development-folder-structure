/* eslint-disable no-unused-vars */
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import helmet from 'helmet';

import sequelize from '#config/db.config';

import authRoutes from '#routes/auth.routes';

const app = express();
const PORT = process.env.PORT;
app.use(helmet());
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  return res.status(200).json({
    success: true,
    message: 'Welcome to JNT Internal Dagsap App Backend',
    data: null,
  });
});

app.get('/ping', (req, res) => {
  return res.status(200).json({
    success: true,
    message: 'Server is running',
    data: {
      timestamp: new Date().toISOString(),
    },
  });
});

app.use('/api/auth', authRoutes);

app.use((req, res) => {
  return res.status(404).json({
    success: false,
    message: 'Route not found',
    data: null,
  });
});

app.use((err, req, res, next) => {
  console.error(err);

  return res.status(500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    data: null,
  });
});

const startServer = async () => {
  try {
    await sequelize.authenticate();

    console.log('Database connected successfully');

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Database connection failed:', error);
  }
};

startServer();
