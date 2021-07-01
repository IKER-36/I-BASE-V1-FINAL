import { useSelector } from "react-redux";
import { RootState } from "../utils/types";
import "./jobmodal.scss";

export const JobModal = () => {
	const { label, grade } = useSelector((state: RootState) => state.data);

	const fullJob = label + " - " + grade;

	return (
		<>
			<div className='job-wrap'>
				<span className='job-icon'>💼</span>
				<span className='job-name'>{fullJob}</span>
			</div>
		</>
	);
};
