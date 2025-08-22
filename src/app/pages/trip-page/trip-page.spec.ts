import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TripPage } from './trip-page';

describe('TripPage', () => {
  let component: TripPage;
  let fixture: ComponentFixture<TripPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TripPage]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TripPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
