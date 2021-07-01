import { FC } from "react";
import "./header.scss";

type HeaderProps = {
	id: number;
	name: string;
};

export const Header: FC<HeaderProps> = ({ id, name }) => {
	return (
		<>
			<div className='header-wrap'>
				<span className='header-id'>{"ID " + id + ":"}</span>
				<span className='header'>{name}</span>
			</div>
		</>
	);
};
