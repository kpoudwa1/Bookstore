import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class PreviousPurchasesComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			previousPurchases : [],
			hasPreviousPurchases : false
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
	
  render() {
    return (
      <div className="PreviousPurchasesComponent">
		<label><h2>Your previous purchases...</h2></label>
		{this.state.hasPreviousPurchases && <div><br/><font className="alert alert-primary">No purchase history found</font><br/><br/></div>}
		{!this.state.hasPreviousPurchases && <div>
			<center>
		<table style={tableStyle} className="table">
			<thead>
				<tr>
					<th>Book</th>
					<th>Quantity</th>
					<th>Order Date</th>
				</tr>
			</thead>
			<tbody>
				{
					this.state.previousPurchases.map(previous => 
							<tr key={previous.title}>
								<td style={imageWidth}><img alt="{previous.title}" width="100px" src={'data:image/jpeg;base64,' + previous.image}/></td>
								<td>{previous.quantity}</td>
								<td>{previous.orderDate}</td>
								
							</tr>
					)
				}
			</tbody>
		</table>
	  </center>
		</div>}
      </div>
    );
  }
  
  componentDidMount()
  {
	UserAPI.executeGetPreviousPurchasesAPIService(20)
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  this.setState({
		  previousPurchases: response.data
	  })
	  
	  if(response.data.length == 0)
	  {
		this.setState({
		  hasPreviousPurchases: true
		})
	  }
	  
	  console.log('Books::::::::: ' + this.state.previousPurchases[0])
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
	width: '60%'
}
const hrStyle = {
  border: 'none',
    height: '1px',
    color: '#333',
    backgroundColor: '#333'
};
var imageWidth =
{
	width: '70px',
	paddingLeft: '15px'
}

export default PreviousPurchasesComponent;