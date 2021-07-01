import { FC } from "react";
import { useSelector } from "react-redux";
import { RootState } from "../utils/types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faMicrophone } from "@fortawesome/free-solid-svg-icons";
import "./playerstats.scss";

export const PlayerStats = () => {
	const { health, armor, hunger, thirst, isTalking } = useSelector(
		(state: RootState) => state.data
	);

	return (
		<>
			<div className='stat-wrap'>
				<StatModal icon='💗' value={health} />
				<StatModal icon='🧥' value={armor} />
				<StatModal icon='🍔' value={hunger} />
				<StatModal icon='🥃' value={thirst} />
				<StatMicModal isTalking={isTalking} />
			</div>
		</>
	);
};

type MicModalProps = {
	isTalking: boolean;
};

const StatMicModal: FC<MicModalProps> = ({ isTalking }) => {
	const talking = {
		height: 100 + "%",
	};

	const notTalking = {
		height: 0 + "%",
	};

	return (
		<>
			{isTalking ? (
				<div className='stat-modal'>
					<div className='stat-value' style={talking}></div>
					<span className='stat-icon'>🎤</span>
				</div>
			) : (
				<div className='stat-modal'>
					<div className='stat-value' style={notTalking}></div>
					<span className='stat-icon'>🎤</span>
				</div>
			)}
		</>
	);
};

type ModalProps = {
	icon: string;
	value: number;
};

const StatModal: FC<ModalProps> = ({ icon, value }) => {
	const height = {
		height: value + "%",
	};

	return (
		<>
			<div className='stat-modal'>
				<div className='stat-value' style={height}></div>
				<span className='stat-icon'>{icon}</span>
			</div>
		</>
	);
};
