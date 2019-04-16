import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import HelloWorldService from '../api/HelloWorldService.js';

class HeaderComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			title : '*'
		}
		this.retrieveWelcomeMessage = this.retrieveWelcomeMessage.bind(this);
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this);
	}
	
  render() {
    return (
      <div className="HeaderComponent">
		<header>
			<nav className="navbar navbar-expand-md navbar-dark bg-dark">
				<div><a href="/" className="navbar-brand"><img border="0" src={require('./logo-bookstore.png')} width="100" height="100"/></a></div>Turn the Page
				<ul className="navbar-nav">
					<li className="nav-link"><Link to="">Home</Link></li>
					<li className="nav-link"><Link to="/dealstoday">Today's Deals</Link></li>
					<li className="nav-link"><Link to="/about">About</Link></li>
				</ul>
				<ul className="navbar-nav navbar-collapse justify-content-end">
					<li className="nav-link"><Link to="/login">Log In</Link></li>
				</ul>
			</nav>
		</header>
      </div>
    );
  }
  
  retrieveWelcomeMessage()
  {
	console.log('AAAAAAAAAAAAA: retrieveWelcomeMessage');
	HelloWorldService.executeHelloWorldService()
	.then(response => this.handleSuccessfulResponse(response))
	//.then(response => console.log(response))
	//.catch()
  }
  
  handleSuccessfulResponse(response)
  {
	  this.setState({title: response.data[0][1]})
  }
}

const searchBoxStyle = {
  width: '500px'
};

export default HeaderComponent;