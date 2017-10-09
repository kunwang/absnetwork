# absnetwork
A network foundation framework based on Alamorefire and ObjectMapper
# CocoaPods
~~~~
pod 'ABSNetwork', '1.0.0'
~~~~

# Usage:
Normal use
~~~~
ABSRequestSessionManager.shared.get("https://www.google.com", params: ["key":"value"], success:{[weak self](request,response) in 
	// do your work
}, fail: {[weak self](request,response) in 
	// do your work
})
~~~~



Generic response use
~~~~
ABSRequestSessionManager.shared.get("https://www.google.com", params: ["key":"value"], success:{[weak self](request,response:ABSGenericResponse<YourObjectMapperObject>) in 
	// do your work
}, fail: {[weak self](request,response) in 
	// do your work
})
~~~~



Requestor use
~~~~
let requestor = ABSRequestor(ABSRequest("https://www.google.com").params([["key":"value"]]).headers(["key":"value"])).delegate(completeHandlerDelegateInstance)
requestor.execute()
~~~~



or 
~~~~
let requestor = ABSRequestor(ABSRequest("https://www.google.com").params([["key":"value"]]).headers(["key":"value"])).handler({[weak self](request,response) in 
	// do your work
}, fail: {[weak self](request,response) in 
	// do your work
})
requestor.execute()
~~~~




Multi requestor all finish request
~~~~
let requestor1 = ABSRequestor(ABSRequest("https://www.google.com").params([["key":"value"]]).headers(["key":"value"])).delegate(delegateInstance)
let requestor2 = ABSRequestor(ABSRequest("https://www.google.com").params([["key":"value"]]).headers(["key":"value"])).delegate(delegateInstance)
let requestorJoiner = ABSRequestorJoiner().join(requestor1).join(requestor2).delegate(requestorJoinerDelegateInstance)
requestorJoiner.execute()
~~~~


