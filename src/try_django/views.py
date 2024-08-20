from django.http import HttpResponse
from django.shortcuts import render
from django.template.loader import get_template
# Dont Repeat Yourself = DRY

from .forms import ContactForm
from blog.models import BlogPost
from datetime import datetime
import requests

def home_page(request):
    print (datetime.now(),'1111111111111111')
    my_title = "Hello there...."
    print (datetime.now(),'2222222222222222222')
    res = requests.get('https://1hafzd3420.execute-api.us-east-1.amazonaws.com/v1/?state_code=6&district_code=36')
    print (datetime.now(),'3333333333333333333333333333333')
    print (res,res.text,'RESPONSE FROM AWS API GATEWAY...')
    qs = BlogPost.objects.all()[:5]
    context = {"title": "Welcome to Try Django", 'blog_list': qs}
    print (datetime.now(),'444444444444444444444444')
    return render(request, "home.html", context)


def about_page(request):
    return render(request, "about.html", {"title": "About"})



def contact_page(request):
    form = ContactForm(request.POST or None)
    if form.is_valid():
        print(form.cleaned_data)
        form = ContactForm()
    context = {
        "title": "Contact us", 
        "form": form
    }
    return render(request, "form.html", context)



def example_page(request):
    context         =  {"title": "Example"}
    template_name   = "hello_world.html" 
    template_obj    = get_template(template_name)
    rendered_item   = template_obj.render(context)
    return HttpResponse(rendered_item)

