export type DataState = {
	isShowing: boolean;
	name: string;
	health: number;
	armor: number;
	hunger: number;
	thirst: number;
	isTalking: boolean;
	label: string;
	grade: string;
	cash: number;
	bank: number;
	dirty: number;
};

const initialDataState = {
	isShowing: true,
	name: "Loading...",
	health: 100,
	armor: 100,
	hunger: 100,
	thirst: 100,
	isTalking: true,
	label: "",
	grade: "",
	cash: 0,
	bank: 0,
	dirty: 0,
};

export const updateData = (
	state = initialDataState,
	action: { type: any; payload: any }
) => {
	switch (action.type) {
		case "update":
			return {
				...state,
				...action.payload,
			};
		default:
			return state;
	}
};
