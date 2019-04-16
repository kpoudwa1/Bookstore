import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import SearchAPI from '../api/SearchAPI.js';

class SearchResultComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			books : []
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
	
  render() {
    return (
      <div className="SearchResultComponent">
		<label><h2>Results...</h2></label>
		<hr/>
		<table style={tableStyle}>
			<tbody>
				{
					this.state.books.map(book => 
							<tr>
								<td style={imageWidth}><img width="70px" src={'data:image/jpeg;base64,' + book.image}/></td>
								<td style={padding} align="left"><Link to={"/bookdetails/" + book.id}>{book.title}</Link></td>
							</tr>
					)
				}
			</tbody>
		</table>
      </div>
    );
  }
  
  handleLoad()
  {
	  console.log('On load')
  }
  
  componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	SearchAPI.executeSearchAPIService(this.props.match.params.title)
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  this.setState({
		  books: response.data
	  })
	  console.log('Books:::::::::')
	  //console.log(this.state.books[0][2])
	  
	  return (
		<div>Hi TEST</div>
	  )
  }
  
  handleErrorResponse(error)
  {
	  if(error.response.status === 404)
		error.response.status = error.response.status + ' Not found';

	  var errorObj =
	  {
		  status: error.response.status,
		  details: error.response.data.details,
		  message: error.response.data.message,
		  timestamp: error.response.data.timestamp
	  }
	  this.props.history.push({
		  pathname: '/error',
		  state: errorObj
	  })
  }
}

var tableStyle = 
{
	width: '90%'
}
var padding = 
{
	padding: '15px',
}
var imageWidth =
{
	width: '70px',
	paddingLeft: '15px'
}

export default SearchResultComponent;