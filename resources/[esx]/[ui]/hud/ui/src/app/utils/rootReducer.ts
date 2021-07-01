import { combineReducers } from "redux";

import { updateData } from "./reducers/updateData";

export const rootReducer = combineReducers({
	data: updateData,
});
