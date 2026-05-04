import { useState, useEffect } from 'react';
import { Box, ProgressBar, Section } from 'tgui-core/components';
import { useBackend } from '../backend';

interface BlinkWarningData {
  duration: number;
}

export const BlinkWarning = (props, context) => {
  const { data } = useBackend<BlinkWarningData>();
  const { duration } = data;
  const [progress, setProgress] = useState(0);
  const [timeLeft, setTimeLeft] = useState(duration);

  useEffect(() => {
    if (!duration) return;
    const startTime = Date.now();
    const interval = window.setInterval(() => {
      const elapsed = Date.now() - startTime;
      const newProgress = Math.min((elapsed / (duration * 1000)) * 100, 100);
      setProgress(newProgress);
      setTimeLeft(Math.max(Math.ceil(duration - elapsed / 1000), 0));
      if (newProgress >= 100) {
        window.clearInterval(interval);
      }
    }, 100);

    return () => window.clearInterval(interval);
  }, [duration]);

  return (
    <Section title="Blink">
      <Box>
        <p>Automatic blink incoming in {timeLeft}s.</p>
        <ProgressBar value={progress} maxValue={100} />
      </Box>
    </Section>
  );
};
