import React, { Component } from 'react';
import HelloWorldService from '../api/HelloWorldService.js';

class SearchComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			title : ''
		}
		this.retrieveWelcomeMessage = this.retrieveWelcomeMessage.bind(this);
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this);
		this.searchByTitle = this.searchByTitle.bind(this)
		this.handleChange = this.handleChange.bind(this)
	}
	
  render() {
    return (
      <div className="SearchComponent">
		<br/>
		<input type="text" name="searchBox" value={this.state.title} onChange={this.handleChange} style={searchBoxStyle} placeholder="Enter the Title here..."/>
		&nbsp;&nbsp;
		<input type="submit" value="Search" onClick={this.searchByTitle}/>
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
  
  searchByTitle()
  {
	  console.log('searchByTitle' );
	  console.log('Search text: ' + this.state.title);
	  this.props.history.push(`/search/${this.state.title}`)
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
  
  handleChange(event)
  {
	  this.setState({
		  title : event.target.value,
	  })
  }
}

const searchBoxStyle = {
  width: '500px'
};

export default SearchComponent;