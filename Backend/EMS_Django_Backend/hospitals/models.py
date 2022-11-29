from django.db import models
from EMS_Django_Backend import constants
from django.core.validators import RegexValidator

# Create your models here.
class SpecialtyCenter(models.Model):
    type = models.CharField(primary_key=True, max_length=100)

    def __str__(self):
        return self.type


class Diversion(models.Model):
    type = models.CharField(primary_key=True, max_length=100)

    def __str__(self):
        return self.type


class Hospital(models.Model):
    # Attributes of a hospital
    name = models.CharField(primary_key=True, max_length=100)
    street = models.CharField(max_length=100, null=False)
    city = models.CharField(max_length=100, null=False)
    county = models.CharField(max_length=100, null=False, default='N/A')
    state = models.CharField(max_length=2, null=False, validators=[RegexValidator(
        r'^((A[LKZR])|(C[AOT])|(D[EC])|(FL)|(GA)|(HI)|(I[DLNA])|(K[SY])|(LA)|(M[EDAINSOT])|(N[EVHJMYCD])|(O[HKR])|(PA)|(RI)|(S[CD])|(T[NX])|(UT)|(V[TA])|(W[AVIY]))$')])
    zip = models.CharField(max_length=5, null=False, validators=[
                           RegexValidator(r'^[0-9]{5}$')])
    lat = models.DecimalField(default=0, max_digits=100, decimal_places=10)
    long = models.DecimalField(default=0, max_digits=100, decimal_places=10)
    phone = models.CharField(verbose_name='phone number', max_length=10, null=False, validators=[RegexValidator(
            regex='^[0-9]*$',
            message='The phone number must only contain numbers in the format 01234567890',
            code='invalid_phone_number'
        )])
    rch = models.CharField(null=True, max_length=100)
    ems_region = models.CharField(null=False, max_length=100)
    specialty_center = models.ManyToManyField(SpecialtyCenter)

    # The status of the hospital. To be updated by the scraper
    last_updated = models.DateTimeField(null=True)
    nedocs_score = models.CharField(null=True, choices=constants.NEDOCS_CHOICES, default=constants.NORMAL, max_length=100)
    diversions = models.ManyToManyField(Diversion)
