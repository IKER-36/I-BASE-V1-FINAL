import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { createStore } from "redux";
import { rootReducer } from "./app/utils/rootReducer";
import { EventListener } from "./app/Nui/NuiHandler";
import { App } from "./app";
import "./index.scss";

export const store = createStore(rootReducer, {});

ReactDOM.render(
	<Provider store={store}>
		<App />
		<EventListener />
	</Provider>,
	document.getElementById("root")
);
