import { type Antagonist, Category } from '../base';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const OperativeMidround: Antagonist = {
  key: 'chaosinsurgencymidround',
  name: 'Chaos Insurgency Midround',
  description: [
    `
      A form of Chaos Insurgency agent that is offered to ghosts in the middle
      of the shift.
    `,
    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default OperativeMidround;
