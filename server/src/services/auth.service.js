import bcrypt from 'bcryptjs';

import db from '#database/models/index';
import { generateAccessToken } from '#utils/jwt';

const { User, Role } = db;

export const loginService = async ({ email, password }) => {
  const user = await User.findOne({
    where: { email },
    include: [
      {
        model: Role,
        as: 'role',
      },
    ],
  });

  if (!user) {
    throw new Error('Invalid email or password');
  }

  const isPasswordValid = await bcrypt.compare(password, user.password);

  if (!isPasswordValid) {
    throw new Error('Invalid email or password');
  }

  if (user.in_active) {
    throw new Error('User account is inactive');
  }

  const token = generateAccessToken({
    id: user.id,
    email: user.email,
    role: user.role.name,
  });

  return {
    token,
    user: {
      id: user.id,
      fullname: user.fullname,
      email: user.email,
      role: user.role.name,
    },
  };
};
