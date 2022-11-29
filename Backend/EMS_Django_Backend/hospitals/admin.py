from django.contrib import admin
from .models import Hospital, SpecialtyCenter, Diversion

admin.site.register(Hospital)
admin.site.register(SpecialtyCenter)
admin.site.register(Diversion)
