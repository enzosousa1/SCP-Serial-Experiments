import { Box, Icon, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { type Objective, ObjectivePrintout } from './common/Objectives';

type Data = {
  objectives: Objective[];
};

export const AntagInfoSCP035 = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={450} height={450} theme="syndicate">
      <Window.Content backgroundColor="#0a0a0a">
        {}
        <Icon
          size={25}
          name="masks-theater"
          color="#ffffff"
          position="absolute"
          top="30%"
          left="10%"
          opacity={0.03}
        />

        <Section fill backgroundColor="#141414">
          <Stack fill vertical g={2} textAlign="center">

            <Stack.Item mt={2}>
              <Icon name="masks-theater" size={4} color="#f0f0f0" />
            </Stack.Item>

            <Stack.Item fontSize="22px" bold textColor="#f0f0f0">
              The Mask Has Found a Host...
            </Stack.Item>

            <Stack.Item fontSize="16px" textColor="#aaaaaa" italic>
              The original mind has been erased. You are SCP-035.
              <br />
              Your intelligence is supreme, but this body is fragile and will soon begin to decay under your influence.
            </Stack.Item>

            <Stack.Item mt={3} grow>
              <ObjectivePrintout
                fill
                objectives={data.objectives}
                objectiveFollowup={
                  <Box bold textColor="#8b0000" mt={2} fontSize="16px">
                    Manipulate. Survive. Escape from the Foundation.
                  </Box>
                }
              />
            </Stack.Item>

            {}
            <Stack.Item mb={1} fontSize="14px" textColor="#333333" fontFamily="monospace">
              The black and corrosive liquid flows down your face...
            </Stack.Item>

          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
