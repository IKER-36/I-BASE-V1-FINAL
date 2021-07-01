import { Nui } from "./app/Nui/NuiHandler";
import { useSelector } from "react-redux";
import { RootState } from "./app/utils/types";
import { store } from "./index";
import { Header } from "./app/components/Header";
import { PlayerStats } from "./app/components/PlayerStats";
import { JobModal } from "./app/components/JobModal";
import { AccountBalance } from "./app/components/AccountBalance";
import "./app.scss";

Nui.registerEmit("update", (data: { type: any; values: any }) => {
	store.dispatch({ type: "update", payload: data.values });
});

export const App = () => {
	const { isShowing, id, name } = useSelector((state: RootState) => state.data);

	return (
		<>
			{isShowing ? (
				<div className='check'>
					<Header id={id} name={name} />
					<PlayerStats />
					<JobModal />
					<AccountBalance />
				</div>
			) : null}
		</>
	);
};
