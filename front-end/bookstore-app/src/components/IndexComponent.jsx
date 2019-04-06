import React, { Component } from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom';
import HelloWorldService from '../api/HelloWorldService.js';
{/*import LoginComponent from './LoginComponent.jsx';
import DealsTodayComponent from './DealsTodayComponent.jsx';
import AboutComponent from './AboutComponent.jsx';*/}

class IndexComponent extends Component {
	constructor()
	{
		super();
		this.state = {
			title : ''
		}
		this.retrieveWelcomeMessage = this.retrieveWelcomeMessage.bind(this);
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this);
	}
  render() {
    return (
      <div className="LearningComponents">
	  {/*<Router>
			<>
				<Switch>
				<Route path="/" exact component={IndexComponent}/>
				<Route path="/login" component={LoginComponent}/>
				<Route path="/dealstoday" component={DealsTodayComponent}/>
				<Route path="/about" component={AboutComponent}/>
				</Switch>
			</>
	  </Router>*/}
		<header>
			<nav className="navbar navbar-expand-md navbar-dark bg-dark">
				<div><a className="navbar-brand">Turn the Page</a></div>
				<ul className="navbar-nav">
					<li className="nav-link">Home</li>
					<li className="nav-link">Today's Deals</li>
					<li className="nav-link">About</li>
				</ul>
				<ul className="navbar-nav navbar-collapse justify-content-end">
					<li className="nav-link">Log In</li>
				</ul>
			</nav>
		</header>
		<br/>
		<input type="text" name="searchBox" style={searchBoxStyle}/>
		&nbsp;&nbsp;
		<input type="submit" value="Search" />
		<div>
			<br/>
			Click here for images&nbsp;&nbsp;
			<button onClick={this.retrieveWelcomeMessage}>Get Images</button>
		</div>
		<div className="container">
			{this.state.title}
		</div>
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

export default IndexComponent;