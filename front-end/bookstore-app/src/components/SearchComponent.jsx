import React, { Component } from 'react';

class SearchComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			title : ''
		}
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
      </div>
    );
  }
  
  searchByTitle()
  {
	  console.log('searchByTitle' );
	  console.log('Search text: ' + this.state.title + '#');
	  console.log('Search text: ' + this.state.title.length + '#');
	  if(this.state.title.length > 0)
		this.props.history.push(`/search/${this.state.title}`)
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