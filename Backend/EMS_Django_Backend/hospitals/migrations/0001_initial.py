from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Diversion',
            fields=[
                ('type', models.CharField(max_length=100, primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='SpecialtyCenter',
            fields=[
                ('type', models.CharField(max_length=100, primary_key=True, serialize=False)),
            ],
        ),
    ]
