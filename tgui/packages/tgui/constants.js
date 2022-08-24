/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

// All game related colors are stored here
export const COLORS = {
  // Department colors
  department: {
    captain: '#c06616',
    security: '#e74c3c',
    medbay: '#3498db',
    science: '#9b59b6',
    engineering: '#f1c40f',
    cargo: '#f39c12',
    centcom: '#00c100',
    other: '#c38312',
  },
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
  // reagent / chemistry related colours
  reagent: {
    acidicbuffer: '#fbc314',
    basicbuffer: '#3853a4',
  },
};

// Colors defined in CSS
export const CSS_COLORS = [
  'black',
  'white',
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
  'good',
  'average',
  'bad',
  'label',
];

/* IF YOU CHANGE THIS KEEP IT IN SYNC WITH CHAT CSS */
export const RADIO_CHANNELS = [
  {
    name: 'Синдикат',
    freq: 1213,
    color: '#8f4a4b',
  },
  {
    name: 'Red Team',
    freq: 1215,
    color: '#ff4444',
  },
  {
    name: 'Blue Team',
    freq: 1217,
    color: '#3434fd',
  },
  {
    name: 'Green Team',
    freq: 1219,
    color: '#34fd34',
  },
  {
    name: 'Yellow Team',
    freq: 1221,
    color: '#fdfd34',
  },
  {
    name: 'ЦентрКом',
    freq: 1337,
    color: '#2681a5',
  },
  {
    name: 'Снабжение',
    freq: 1347,
    color: '#b88646',
  },
  {
    name: 'Обслуживание',
    freq: 1349,
    color: '#6ca729',
  },
  {
    name: 'Научный',
    freq: 1351,
    color: '#c68cfa',
  },
  {
    name: 'Командование',
    freq: 1353,
    color: '#fcdf03',
  },
  {
    name: 'Медбей',
    freq: 1355,
    color: '#57b8f0',
  },
  {
    name: 'Инженерия',
    freq: 1357,
    color: '#f37746',
  },
  {
    name: 'Безопасность',
    freq: 1359,
    color: '#dd3535',
  },
  {
    name: 'Приватный ИИ',
    freq: 1447,
    color: '#d65d95',
  },
  {
    name: 'Основной',
    freq: 1459,
    color: '#1ecc43',
  },
];

const GASES = [
  {
    id: 'o2',
    name: 'Воздух (O₂)',
    label: 'O₂',
    color: 'blue',
  },
  {
    id: 'n2',
    name: 'Азот (N₂)',
    label: 'N₂',
    color: 'red',
  },
  {
    id: 'co2',
    name: 'Диоксид Углерода (CO₂)',
    label: 'CO₂',
    color: 'grey',
  },
  {
    id: 'plasma',
    name: 'Плазма',
    label: 'Плазма',
    color: 'pink',
  },
  {
    id: 'water_vapor',
    name: 'Водяной Пар (H₂O)',
    label: 'H₂O',
    color: 'lightsteelblue',
  },
  {
    id: 'nob',
    name: 'Гипер-ноблий',
    label: 'Гипер-ноб',
    color: 'teal',
  },
  {
    id: 'n2o',
    name: 'Закись Азота (N₂O)',
    label: 'N₂O',
    color: 'bisque',
  },
  {
    id: 'no2',
    name: 'Нитрил (no2)',
    label: 'NO₂',
    color: 'brown',
  },
  {
    id: 'tritium',
    name: 'Тритиум',
    label: 'Тритиум',
    color: 'limegreen',
  },
  {
    id: 'bz',
    name: 'БЗ',
    label: 'БЗ',
    color: 'mediumpurple',
  },
  {
    id: 'pluox',
    name: 'Плюоксиум',
    label: 'Плюоксиум',
    color: 'mediumslateblue',
  },
  {
    id: 'miasma',
    name: 'Миазма',
    label: 'Миазма',
    color: 'olive',
  },
  {
    id: 'Freon',
    name: 'Фреон',
    label: 'Фреон',
    color: 'paleturquoise',
  },
  {
    id: 'hydrogen',
    name: 'Водород (H₂)',
    label: 'H₂',
    color: 'white',
  },
  {
    id: 'healium',
    name: 'Геалий',
    label: 'Геалий',
    color: 'salmon',
  },
  {
    id: 'proto_nitrate',
    name: 'Прото Нитрат',
    label: 'Прото-нитрат',
    color: 'greenyellow',
  },
  {
    id: 'zauker',
    name: 'Заукер',
    label: 'Заукер',
    color: 'darkgreen',
  },
  {
    id: 'halon',
    name: 'Галон',
    label: 'Галон',
    color: 'purple',
  },
  {
    id: 'helium',
    name: 'Гелий (He)',
    label: 'He',
    color: 'aliceblue',
  },
  {
    id: 'antinoblium',
    name: 'Антиноблиум',
    label: 'Анти-Ноблиум',
    color: 'maroon',
  },
];

export const getGasLabel = (gasId, fallbackValue) => {
  const gasSearchString = String(gasId).toLowerCase();
  // prettier-ignore
  const gas = GASES.find((gas) => (
    gas.id === gasSearchString
      || gas.name.toLowerCase() === gasSearchString
  ));
  return (gas && gas.label) || fallbackValue || gasId;
};

export const getGasColor = (gasId) => {
  const gasSearchString = String(gasId).toLowerCase();
  // prettier-ignore
  const gas = GASES.find((gas) => (
    gas.id === gasSearchString
      || gas.name.toLowerCase() === gasSearchString
  ));
  return gas && gas.color;
};
