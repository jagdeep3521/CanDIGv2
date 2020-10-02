from selenium import webdriver
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary

from selenium.webdriver.common.keys import Keys
import os
import unittest
import time

import pytest


# -- helper functions --

def login(driver, username, password):
    # ensure we were redirected
    assert "Log in to candig" in driver.title

    username_input = driver.find_elements_by_xpath("//*[@id='username']")[0]
    password_input = driver.find_elements_by_xpath("//*[@id='password']")[0]

    login_button = driver.find_elements_by_xpath("//*[@id='kc-login']")[0]

    username_input.send_keys(username)
    password_input.send_keys(password)

    login_button.click()

# -- - --


@pytest.mark.usefixtures("setup")
class TestAuthorizations():
    
    def test_bob(self):
        self.driver.get(self.candig_url)

        # credentials
        u1 = os.environ["KC_TEST_USER"]
        p1 = os.environ["KC_TEST_PW"]
        login(self.driver, u1, p1)
        
        time.sleep(self.debug_pause_time)

        # verify successful login
        text=self.driver.find_elements_by_xpath("/html/body/div[1]/div[1]/a[2]")[0].text
        assert "dashboard" in text.lower()


    def test_alice(self):
        self.driver.get(self.candig_url)

        # credentials
        u2 = os.environ["KC_TEST_USER_TWO"]
        p2 = os.environ["KC_TEST_PW_TWO"]
        login(self.driver, u2, p2)

        time.sleep(self.debug_pause_time)

        # verify denied login
        assert "Access Denied" in self.driver.find_elements_by_tag_name("body")[0].text

