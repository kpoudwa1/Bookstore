import React, { Component } from 'react';
import {BrowserRouter as Router, Route, Switch} from 'react-router-dom';
import HelloWorldService from '../api/HelloWorldService.js';
import LoginComponent from './LoginComponent';
import DealsTodayComponent from './DealsTodayComponent';
import AboutComponent from './AboutComponent';
import UserHomeComponent from './UserHomeComponent';
import ErrorComponent from './ErrorComponent';
import HeaderComponent from './HeaderComponent';
import SearchComponent from './SearchComponent';
import FooterComponent from './FooterComponent';
import SearchResultComponent from './SearchResultComponent';
import BookDetailsComponent from './BookDetailsComponent';

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
		<Router>
				<>
					<HeaderComponent/>
					<Switch>
						<Route path="/" exact component={SearchComponent}/>
						<Route path="/login" component={LoginComponent}/>
						<Route path="/dealstoday" component={DealsTodayComponent}/>
						<Route path="/about" component={AboutComponent}/>
						<Route path="/home" component={UserHomeComponent}/>
						<Route path="/search/:title" component={SearchResultComponent}/>
						<Route path="/bookdetails/:id" component={BookDetailsComponent}/>
						<Route component={ErrorComponent}/>
					</Switch>
					<FooterComponent/>
				</>
		</Router>
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

export default IndexComponent;