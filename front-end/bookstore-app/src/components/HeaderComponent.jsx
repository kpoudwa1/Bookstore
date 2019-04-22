import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import Logo from '../logo-dark.png';
import UserAPI from '../api/UserAPI.js';

class HeaderComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			title : '*'
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this);
	}
	
  render() {
	  const isUserLoggedIn = UserAPI.isUserLoggedIn();
    return (
      <div className="HeaderComponent">
		<header>
			<nav className="navbar navbar-expand-md navbar-dark bg-dark">
				<div><Link to=""><img alt="Turn the page" src={Logo} width="50" height="50"/></Link></div>
				<ul className="navbar-nav">
					<li className="nav-link"><Link to="/dealstoday">Today's Deals</Link></li>
					<li className="nav-link"><Link to="/about">About</Link></li>
				</ul>
				<ul className="navbar-nav navbar-collapse justify-content-end">
					{isUserLoggedIn && <li className="nav-link"><Link to="/userCart">MyCart</Link></li>}
					{isUserLoggedIn && <li className="nav-link"><Link to="/trackorder">Track orders</Link></li>}
					{isUserLoggedIn && <li className="nav-link"><Link to="/previouspurchase">Previous purchases</Link></li>}
					{isUserLoggedIn && <li className="nav-link"><Link to="/changeaddress">Update Address</Link></li>}
					{!isUserLoggedIn && <li className="nav-link"><Link to="/login">Log In</Link></li>}
					{isUserLoggedIn && <li className="nav-link"><Link to="/logout" onClick={UserAPI.registerLogout}>Logout</Link></li>}
				</ul>
			</nav>
		</header>
      </div>
    );
  }
   
  handleSuccessfulResponse(response)
  {
	  this.setState({title: response.data[0][1]})
  }
}

export default HeaderComponent;