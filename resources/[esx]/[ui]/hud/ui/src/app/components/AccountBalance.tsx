import { FC } from "react";
import { useSelector } from "react-redux";
import { RootState } from "../utils/types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faDollarSign } from "@fortawesome/free-solid-svg-icons";
import "./accountbalance.scss";

export const AccountBalance = () => {
	const { cash, bank, dirty } = useSelector((state: RootState) => state.data);

	return (
		<>
			<div className='account-wrap'>
				<BalanceModal icon='💸' value={cash} />
				<BalanceModal icon='💳' value={bank} />
				<BalanceModal icon='🔞' value={dirty} />
			</div>
		</>
	);
};

type ModalProps = {
	icon: any;
	value: any;
};

const BalanceModal: FC<ModalProps> = ({ icon, value }) => {
	return (
		<>
			<div className='balance-wrap'>
				<span className='balance-type'>{icon}</span>
				<span className='balance-amount'>{value}</span>
				<div className='icon-wrap'>
					<FontAwesomeIcon className='balance-currency' icon={faDollarSign} />
				</div>
			</div>
		</>
	);
};
