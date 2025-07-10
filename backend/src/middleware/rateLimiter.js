import { Ratelimit } from '@upstash/ratelimit';
import { redis } from '../config/upstash.js';
const ratelimit = new Ratelimit({
  redis,
  limiter: Ratelimit.slidingWindow(100, '60 s'),
});
const rateLimiter = async (req, res, next) => {
  try {
    const { success } = await ratelimit.limit(`rl:${req.ip}`);
    if (!success) {
        return res.status(429).json({ message: 'Trop de requêtes, veuillez réessayer plus tard.' });
    }
    next();
  } catch (error) {
    res.status(429).json({ error: "Limite de débit dépassée" });
  }
};

export default rateLimiter;