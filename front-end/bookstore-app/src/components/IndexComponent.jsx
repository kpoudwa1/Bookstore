import React, { Component } from 'react';
import {BrowserRouter as Router, Route, Switch} from 'react-router-dom';
import LoginComponent from './LoginComponent';
import DealsTodayComponent from './DealsTodayComponent';
import AboutComponent from './AboutComponent';
import UserHomeComponent from './UserHomeComponent';
import ErrorComponent from './ErrorComponent';
import HeaderComponent from './HeaderComponent';
import SearchComponent from './SearchComponent';
import SearchResultComponent from './SearchResultComponent';
import BookDetailsComponent from './BookDetailsComponent';
import CreateAccountComponent from './CreateAccountComponent';
import LogoutComponent from './LogoutComponent';
import CartComponent from './CartComponent';
import TrackOrderComponent from './TrackOrderComponent';
import PreviousPurchasesComponent from './PreviousPurchasesComponent';
import UpdateAddressComponent from './UpdateAddressComponent';
import AuthenticatedRoute from './AuthenticatedRoute';

class IndexComponent extends Component {
	constructor()
	{
		super();
		this.state = {
			title : ''
		}
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
						<Route path="/logout" component={LogoutComponent}/>
						<Route path="/dealstoday" component={DealsTodayComponent}/>
						<Route path="/about" component={AboutComponent}/>
						<Route path="/home" component={UserHomeComponent}/>
						<Route path="/search/:title" component={SearchResultComponent}/>
						<Route path="/bookdetails/:id" component={BookDetailsComponent}/>
						<Route path="/createAccount" component={CreateAccountComponent}/>
						<AuthenticatedRoute path="/userCart" component={CartComponent}/>
						<AuthenticatedRoute path="/trackorder" component={TrackOrderComponent}/>
						<AuthenticatedRoute path="/previouspurchase" component={PreviousPurchasesComponent}/>
						<AuthenticatedRoute path="/changeaddress" component={UpdateAddressComponent}/>
						<Route path="/error" component={ErrorComponent}/>
						<Route component={ErrorComponent}/>
					</Switch>
				</>
		</Router>
      </div>
    );
  }
  
  handleSuccessfulResponse(response)
  {
	  this.setState({title: response.data[0][1]})
  }
}

export default IndexComponent;