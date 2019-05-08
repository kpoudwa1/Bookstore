import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import SearchAPI from '../api/SearchAPI.js';

class SearchResultComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			books : [],
			errorMessage : '',
			isError : false
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
	
  render() {
    return (
      <div className="SearchResultComponent">
		<label><h2>Displaying the results...</h2></label>
		<center>
			{this.state.isError && <div><br/><font className="alert alert-danger">{this.state.errorMessage}</font><br/><br/></div>}
			<table style={tableStyle} className="table">
			<tbody>
				{
					this.state.books.map(book => 
							<tr key={book.id}>
								<td style={imageWidth}><img alt="{book.title}" width="100px" src={'data:image/jpeg;base64,' + book.image}/></td>
								<td style={padding} align="left"><Link to={"/bookdetails/" + book.id}><h5>{book.title}</h5></Link></td>
							</tr>
					)
				}
			</tbody>
		</table>
		</center>
      </div>
    );
  }
    
  componentDidMount()
  {
	SearchAPI.executeSearchAPIService(this.props.match.params.title)
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  this.setState({ books: response.data })
  }
  
  handleErrorResponse(error)
  {
	  if(!error.response)
		  this.props.history.push({ pathname: '/error' })
	  else
		  this.setState({errorMessage : error.response.data.message, isError : true});
  }
}

var tableStyle = 
{
	width: '50%'
}
var padding = 
{
	padding: '15px',
	paddingLeft: '55px'
}
var imageWidth =
{
	width: '70px',
	paddingLeft: '15px'
}

export default SearchResultComponent;