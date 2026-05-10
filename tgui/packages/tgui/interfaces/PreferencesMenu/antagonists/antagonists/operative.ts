import { type Antagonist, Category } from '../base';

export const OPERATIVE_MECHANICAL_DESCRIPTION = `
  Retrieve the nuclear authentication disk, use it to activate the nuclear
  fission explosive, and destroy the station.
`;

const Operative: Antagonist = {
  key: 'chaosinsurgency',
  name: 'Chaos Insurgency',
  description: [
    `
      Congratulations, agent. Your mission
      is to destroy Foundation's most advanced research facility!
      That's right, you're going to [REDACTED].
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Operative;
