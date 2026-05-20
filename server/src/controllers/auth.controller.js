import { loginSchema } from '#validations/auth.validation';
import { loginService } from '#services/auth.service';

export const login = async (req, res, next) => {
  try {
    const validatedData = loginSchema.parse(req.body);
    const result = await loginService(validatedData);

    return res.status(200).json({
      success: true,
      message: 'Login successful',
      data: result,
    });
  } catch (error) {
    next(error);
  }
};
