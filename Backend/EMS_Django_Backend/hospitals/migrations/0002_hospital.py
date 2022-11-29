import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('hospitals', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Hospital',
            fields=[
                ('name', models.CharField(max_length=100, primary_key=True, serialize=False)),
                ('street', models.CharField(max_length=100)),
                ('city', models.CharField(max_length=100)),
                ('county', models.CharField(default='N/A', max_length=100)),
                ('state', models.CharField(max_length=2, validators=[django.core.validators.RegexValidator('^((A[LKZR])|(C[AOT])|(D[EC])|(FL)|(GA)|(HI)|(I[DLNA])|(K[SY])|(LA)|(M[EDAINSOT])|(N[EVHJMYCD])|(O[HKR])|(PA)|(RI)|(S[CD])|(T[NX])|(UT)|(V[TA])|(W[AVIY]))$')])),
                ('zip', models.CharField(max_length=5, validators=[django.core.validators.RegexValidator('^[0-9]{5}$')])),
                ('phone', models.CharField(max_length=10, validators=[django.core.validators.RegexValidator(code='invalid_phone_number', message='The phone number must only contain numbers in the format 01234567890', regex='^[0-9]*$')], verbose_name='phone number')),
                ('rch', models.CharField(max_length=100, null=True)),
                ('ems_region', models.CharField(max_length=100)),
                ('last_updated', models.DateTimeField(null=True)),
                ('nedocs_score', models.CharField(choices=[('Normal', 'Normal'), ('Busy', 'Busy'), ('Overcrowded', 'Overcrowded'), ('Severe', 'Severe')], default='Normal', max_length=100, null=True)),
                ('diversions', models.ManyToManyField(to='hospitals.Diversion')),
                ('specialty_center', models.ManyToManyField(to='hospitals.SpecialtyCenter')),
            ],
        ),
    ]
