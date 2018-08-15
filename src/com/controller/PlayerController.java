package com.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by 11084919 on 2018/8/10.
 */
@Controller
@RequestMapping("")
public class PlayerController {

    @RequestMapping("index")
    public ModelAndView index(){
        ModelAndView view = new ModelAndView();
        view.setViewName("index");
        return view;
    }

    @RequestMapping("qianbaidu")
    public ModelAndView qianbaidu(){
        ModelAndView view = new ModelAndView();
        view.setViewName("PlayerView");
        view.addObject("cFlag",0);
        return view;
    }

    @RequestMapping("suzhouchengwaideweixiao")
    public ModelAndView suzhouchengwaideweixiao(){
        ModelAndView view = new ModelAndView();
        view.setViewName("PlayerView");
        view.addObject("cFlag",1);
        return view;
    }


}