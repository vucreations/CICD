from django.test import TestCase

import unittest
from django.test import RequestFactory
from django.http import Http404
from blog.views import blog_post_detail_view

def test_existing_slug(self):
    # Test with an existing slug
    request = self.factory.get('/blog/test-post/')
    response = blog_post_detail_view(request, slug='test-post')
    self.assertEqual(response.status_code, 200)  # HTTP OK
    self.assertEqual(response.context_data['object'], self.blog_post)  # Check if the correct object is in the context


def test_non_existing_slug(self):
    # Test with a non-existing slug
    request = self.factory.get('/blog/non-existing-post/')
    with self.assertRaises(Http404):
        blog_post_detail_view(request, slug='non-existing-post')

def test_empty_slug(self):
    # Test with an empty slug
    request = self.factory.get('/blog/')
    with self.assertRaises(Http404):
        blog_post_detail_view(request, slug='')

def test_special_characters_slug(self):
    # Test with special characters in the slug
    request = self.factory.get('/blog/!@#$%/')
    with self.assertRaises(Http404):
        blog_post_detail_view(request, slug='!@#$%')

def test_long_slug(self):
    # Test with a long slug
    long_slug = 'a' * 201
    request = self.factory.get(f'/blog/{long_slug}/')
    with self.assertRaises(Http404):
        blog_post_detail_view(request, slug=long_slug)