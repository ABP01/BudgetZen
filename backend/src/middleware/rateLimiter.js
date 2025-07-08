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
        return res.status(429).json({ message: 'Too many requests, please try again later.' });
    }
    next();
  } catch (error) {
    res.status(429).json({ error: "Rate limit exceeded" });
  }
};

export default rateLimiter;