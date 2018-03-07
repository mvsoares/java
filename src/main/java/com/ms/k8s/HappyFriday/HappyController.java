package com.ms.k8s.HappyFriday;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HappyController {
	@RequestMapping("/")
	public String index() {
		return "OK";
	}

	@RequestMapping("/quote")
	public String quote() {
		return HappyQuoteFactory.getQuote();
	}
}
